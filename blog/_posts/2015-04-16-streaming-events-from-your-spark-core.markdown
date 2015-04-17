---
layout:     post
title:      "Streaming events from your Spark core to Waylay"
date:       2015-04-16 14:59:06
categories: integration
---
Hi, this is our first more technical blog post, you can expect more soon.

#Spark Core

So what us a Spark Core? Some of you might have though about Apache Spark when
reading the blog title but we are talking about [Spark.io][sparkio].
This is what their website mentions:

> Spark offers a suite of hardware and software tools to help you
> prototype, scale, and manage your Internet of Things products.

Currently, their main offering is a hardware device similar to an Arduino but way smaller. It is fully wifi enabled, can be programmed over the web and comes with the needed libraries to connect it to the Spark cloud infrastructure. Have a look at their [documentation][sparkdocs] if you want to dig a bit deeper.

#Integration

This blog post will show you how you can connect a simple motion sensor to
your spark core and send the motion events to the waylay platform. We will then
set up a waylay task that will consume these events and send out and email when
motion is detected.

#What you need

* A Spark Core
* A PIR sensor, we are using a [Parallax PIR Sensor][parallax-pir]
* Some electrical wires
* Credentials to log in to the spark.io build environment
* Credentials to log in to your waylay environment. Click the Start a Free Trial button on [our website][waylayio] to request an account.

#Connecting the motion sensor

![Spark core connections picture]({{ site.baseurl }}/assets/images/sparkcore.jpg)

This is how the connections are set up

* PIR OUT &rarr; Spark D0
* PIR GND &rarr; Spark GND
* PIR VCC &rarr; Spark 3V3

The Digital input number 0 will receive the motion signal. Our sensor keeps the
signal ON for about one second and then drops back to OFF. As you can see in the
picture the sensor also indicates motion by showing a light red glow on the
sides.

#Programming the Spark Core

Now go to the [spark build environment][sparkdev]. Select your spark core and
enter the following code:

{% highlight C linenos %}
int PIN_PIR = D0;

bool motion = false;

void setup()
{  
    pinMode(PIN_PIR, INPUT);
    Spark.variable("motion", &motion, BOOLEAN);
}

void loop()
{
    int oldMotion = motion;
    motion = digitalRead(PIN_PIR);
    if(oldMotion != motion){
        Spark.publish(motion ? "waylay/motion-detected" : "waylay/motion-stopped");
    }
}
{% endhighlight %}

Upload the program to the core with the PIR sensor. Go to the
[spark dashboard][sparkdashboard] to check if your events are being submitted
properly. You should see something similar to the next screenshot. You can ignore the webhook events for now, we are going to set that up in the next section.

![Spark dashboard screenshot]({{ site.baseurl }}/assets/images/sparkdashboard.png)

#Forwarding the spark events to the Waylay broker

There are different paths to integration. We could for example use a C MQTT
library and directly connect to the Waylay broker. But since I'm not too fond
of having to write too much in C we are going to use the Spark platform
[webhooks][sparkwebhooks].

Create a file named `motion.json` with the following contents. Don't forget to
replace `yourdevice`, `yourenv.waylay.io`, `your_waylay_api_key` and `your_waylay_api_secret`
with the appropriate values.

{% highlight json %}
{% raw %}
{
  "eventName": "waylay/motion",
  "url": "https://data.waylay.io/resources/yourdevice?domain=yourenv.waylay.io",
  "requestType": "POST",
  "auth": {
    "username": "your_waylay_api_key",
    "password": "your_waylay_api_secret"
  },
  "json": {
        "name": "{{SPARK_EVENT_NAME}}",
        "value": "{{SPARK_EVENT_VALUE}}",
        "source": "{{SPARK_CORE_ID}}"
  },
  "mydevices": true
}
{% endraw %}
{% endhighlight %}

This webhook will pick up all `waylay/motion` prefixed events and send them to
the waylay data broker.

Make sure you have the Spark CLI [installed][sparkcli] and run the following
command on your terminal:

{% highlight bash %}
$ spark webhook create motion.json
{% endhighlight %}

Check if the hook is installed correctly.

{% highlight bash %}
$ spark webhook list
Found 1 hooks registered

    1.) Hook #5524eecf3aa0d70d2529aaaa is watching for "waylay/motion"
        and posting to: https://data.waylay.io/resources/yourdevice?domain=yourenv.waylay.io
        created at 2015-04-08T09:03:11.555Z
{% endhighlight %}  

You should now also see webhook events popping up on the Spark dashboard. Check
the responses sent by the waylay server to see if everything is working properly.

#Creating the waylay sensor

As there is no provided sensor for a motion sensor we will quicky create one.
This sensor will inspect the incoming data and translate it into a MOTION /
NOMOTION state.
Create a new sensor, enter 2 states `MOTION` and `NOMOTION`, remove the example
property/raw data items and paste the following code into the editor:

{% highlight javascript linenos %}
var eventName = options.rawData.GLOBAL.name;
var value = {
    observedState: eventName == "waylay/motion-detected" ? "MOTION" : "NOMOTION",
    rawData: {data: options.rawData.GLOBAL}
};
send(null, value);
{% endhighlight %}

Save the sensor as `Motion` version `1.0.0`

#Bringing it all together

Almost there. All we need now is a Waylay template that receives the events and
sends out an email.

Open the template editor and start by dragging in your newly created `Motion`
sensor. Now drag in a mail actuator and connect the sensor to it.

Apply the following configuration to the motion sensor:

* resource: `yourdevice` (same as used in the Spark webhook)

Apply the following configuration to the mail actuator:

* address: `you@yourmail.com`
* subject: `intrusion`
* message: `Motion detected!`
* State triggers, enable `MOTION`
* Trigger policy: `Frequency` with value `300` sec

After enabling the labels the end result should look like this:
![Waylay motion template]({{ site.baseurl }}/assets/images/motion.png)

Now click on the debug tab and start the debug task. When the first motion event
is received the task will send you an email. The mail actuator will not send
further events until 5 minutes have passed.

#Concluding

As you can see integrating other services with the Waylay platform is easy.
We only used http but we also support other protocols like MQTT or WebSockets.

In this post we touched only a very small part of the Waylay IoT integration
platform. Feel free to check the Waylay [documentation][waylaydocs] and try out some more
complex scenarios, we are eager to hear about your experiments!


[waylayio]:       https://www.waylay.io/
[waylaydocs]:     https://docs.waylay.io/
[sparkio]:        https://www.spark.io/
[sparkdocs]:      http://docs.spark.io/
[sparkdev]:       https://build.spark.io
[sparkdashboard]: https://dashboard.spark.io/
[sparkwebhooks]:  http://docs.spark.io/webhooks/
[sparkcli]:       http://docs.spark.io/cli
[parallax-pir]:   https://www.parallax.com/product/555-28027
