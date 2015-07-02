---
layout:     post
title:      "Integrating Waylay and IFTTT (IF This Then That)"
date:       2015-06-30 14:59:06
categories: integration
---
#IFTTT
> IFTTT is a web-based service that allows users to create chains of simple conditional statements, called "recipes", which are triggered based on changes to other web services such as Gmail, Facebook, Instagram, and Craigslist. https://en.wikipedia.org/wiki/IFTTT

#Integration

In this blog post, you will learn how to connect between Waylay and IF in two separate chapters:
* From Waylay to IF
* From IF to Waylay

#What you need

* An IFTTT account
* A Waylay account: Click the Start a Free Trial button on [our website][waylayio] to request an account.

#From Waylay to IF
#IF Maker Channel

Using IF's [Maker] channel and Waylay's IFTTTMaker actuator we can send a POST request to trigger your IF recipes.
First, you will need to have a recipe on IFTTT ready to receive a web request.
For "IF" channel, choose the Maker Channel and an event name (e.g. waylay_test).
![IFTTT_tut_step2 screenshot]({{ site.baseurl }}/assets/images/IFTTT_tut_step2.JPG)
![IFTTT_tut_step3 screenshot]({{ site.baseurl }}/assets/images/IFTTT_tut_step3.JPG)

Then pick any "THEN" channel you wish. (e.g. send email)
![IFTTT_tut_step5 screenshot]({{ site.baseurl }}/assets/images/IFTTT_tut_step5.JPG)
![IFTTT_tut_step6 screenshot]({{ site.baseurl }}/assets/images/IFTTT_tut_step6.JPG)
![IFTTT_tut_step7 screenshot]({{ site.baseurl }}/assets/images/IFTTT_tut_step7.JPG)

#Waylay IFTTTMaker Actuator

After logging into your Waylay platform, we'll create a template which consist of a switch sensor and IFTTTMaker actuator.
Enter the eventName (e.g. waylay_test) and the values you wish to have.
![IFTTT_tut_template screenshot]({{ site.baseurl }}/assets/images/IFTTT_tut_template.JPG)

We need the IF account's secretKey for the actuator to be able to connect to IF. Find your secret key at [maker] page.
![IFTTT_tut_maker screenshot]({{ site.baseurl }}/assets/images/IFTTT_tut_maker.JPG)

And enter the secretKey in the actuator's properties field:
![IFTTT_tut_secretKey screenshot]({{ site.baseurl }}/assets/images/IFTTT_tut_prop_secretkey.JPG)

If you haven't already, connect the switch sensor node to the IFTTTMaker actuator node and change the following under advance settings on the actuator node:
Trigger on state change: off -> on

You are now ready to trigger some IF recipes from Waylay!
Simply go under the debug tab and RUN the template! Click on the "Test data" button, and push "on" to switch_1 node.
The result is switch_1 node changing state from OFF to ON and therefore triggering the IFTTTMaker actuator.

#From IF to Waylay

Coming soon!

#Concluding

Coming soon!

[waylayio]:       https://www.waylay.io/
[waylaydocs]:     https://docs.waylay.io/
[maker]:          https://ifttt.com/maker
