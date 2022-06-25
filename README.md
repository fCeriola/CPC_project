# E infine uscimmo a riveder le stelle

- [E infine uscimmo a riveder le stelle](#e-infine-uscimmo-a-riveder-le-stelle)
- [Introduction](#introduction)
- [Discovering the project](#discovering-the-project)
- [Technical Explanation](#technical-explanation)
- [Inside the scene](#inside-the-scene)
- [Moon](#moon)
- [Sun](#sun)
- [Stars](#stars)
- [star](#star)
- [starsTable](#starstable)
- [starSystem](#starsystem)
- [Sky](#sky)
- [sky](#sky-1)
- [pollution](#pollution)
- [OSC communication](#osc-communication)
- [GyrOSC](#gyrosc)
- [Ableton Live](#ableton-live)

# Introduction
Our project is about lights pollution. 
Lights pollution contributes to climate change, modifies in a negative way trees natural cycles, kills birds every year and causes health problems, because 
we are exposed to artificial light during nighttime. 
Artificial light makes us blind to the real night sky, because, especially in big cities, lights pollution covers the real natural beauty of everything above us.
Imagine now you can switch off all the artificial lights, and discover what is behind this layer of pollution, with astonishment and surprise. 

# Discovering the project 
- Physical Tools: 
For the installation, we give the user the possibility to use his/her phone as a sort of "flashlight", pointing on the screen and discovering what there is
behind the pollution layer. 
The installation will be displayed above the user to emulate night sky view. 

- Software Tools: 
There is a interaction with OSC messages between the stars and Ableton to produce sound. 

# Technical Explanation 
We started from a giant database containing stars' coordinates and parameters in J2000, from which we calculated the actual position of the stars with a time-shift formula.
After that, stars are displayed on the installation and they move with respect to a timer set when the application starts, calculating the actual data. 
When the application starts, the user is allowed to use a gyroscope to move the little lens on the screen, that makes the user able to discover the stars under the pollution layer.
The gyroscope on the phone communicates with the application with OSC messages, that are also sent to Ableton in order to produce sound when the user moves the lens on the application. 
The following chapters are the detailed explanation of every tool and function used in the application. 

# Inside the scene 
There are two different scenarios, nighttime and daytime. 
The first is governed by the presence of the moon, and is more "discovering", due to the fact that the user has a complete visibility of the sky in the background.
The second one by the presence of the sun, and it's counterposed to the more introversial and dark nighttime. 
There are two classes referring to the moon and the sun, explained below. 

# Moon 
The moon class is a representation of the moon, made by using some perlin noise. 
The algorithm used is the classic Perlin Noise in 2D algorithm...

# Sun 
The sun are concentric ellypsis, where the color gradient is obtained by using lerpColor method, and it is made using processing.sound library;
Rays are depicted as FFT of incoming audio from Ableton, where amplitude bands are represented on the sun circumference. 

# Stars
The stars part is the most complicated of the application, and is the main core of the installation. 
There are three main tables involving the implementation of the stars: star, starsTable, starSystem.

# star
The class star containes information about the single star.
In the constructor of the class we take a row from the Stars database and get out from it the values that we need: 
In the ConvColor method, we take the temperature values from the table and compute the color based on the temperature. 
Then in the fromHorizToCart method we convert the horizontal coordinates obtained from the db into cartesian ones. 

# starsTable
starsTable is the main component part of all three stars tables, basically we operate taking parameters and coordinates of the stars, read from a J2000
reference in equatorial coordinates. 
...

# starSystem 
starSystem class manages the single star object, and containes an ArrayList of stars. 
In the constructor of the component we pass the reference to the database to the constructor itself, creating basically a new reference, so a new pointer. 
There are two methods, fillSystem, used to take stars from the database and put them into the arraylist; this information is constantly updated by the update method and starsFallIntoScreen, that is used to discriminate what stars are to include in the maximum height and width set for the application screen. 
Finally, stars are plotted with the plot method. 

# Sky 
The sky part creates the scenario of the installation, and it is divided in two main parts: sky and pollution. 

# sky
Sky is made by concentric circles, where the color gradient is made using lerpColor method. 
The opacity is instead obtained using the amplitude of the incoming signal.

# pollution
Pollution is made by using a perlin noise changed with time 
...

# OSC communication 
The communication part is divided into two main parts, the communication with Ableton Live and the communication with GyrOSC

# GyrOSC
The communication with GyrOSC takes place in the main, with the method oscEvent.
We take three parameters from GyrOSC that are the gyroscope, the accelerometer and the GPS. 
Every parameter has an associated OSCAddress that is taken by Processing and from which we take the relevant attributes of each parameter. 
For the gyroscope parameters used are beccheggio and rollio, for the accelerometer is the quantity of acceleration in the x and y axis and for the GPS are the coordinates of the position where GyrOSC is activated. 
These parameters are taken by calling arguments() method.
For our application we needed to split all three parameters, and that has been made by calling the CheckAddrPattern method, so that we could manage the values coming from the gyroscope, accelerometer and GPS separately.

# Ableton Live
Hi everyone




 
 





