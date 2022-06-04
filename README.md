# E infine uscimmo a riveder le stelle

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
The sun are concentric ellypsis, made using processing.sound library;
Rays are depicted as FFT of incoming audio from Ableton, where amplitude bands are represented on the sun circumference. 

# Stars
The stars part is the most complicated of the application, and is the main core 
 
 





