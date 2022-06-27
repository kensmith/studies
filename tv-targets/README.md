# Motivation

This project is an attempt to make accurate minute of angle
(MOA) sized targets that you can display on a 1080p TV in
order to conduct dry fire practice for precision rifle.

# Usage

The first step is to determine how many pixels one
milliradian (mil) subtends in your reticle when you look at
your display through it. Display calibration.gif fullscreen
on your TV or monitor and line your reticle up with one of
the squares that descends from the upper left corner of the
screen and count its position from the first square. They go
in order of 1 pixel, 2px, 3px, and so on. Once you find the
square that most closely matches 1 full milliradian in your
scope, you can use the gif that matches that number. For
example, if one mil in your reticle subtends 7 pixels, then
use 07.gif. The white targets are the half MOA targets and
the green targets are whole MOA targets.

Now the squares in the middle of the screen are moa accurate
from 0.5, increasing in size by 0.5 (the next larger target
is 1.0 moa, the one above that is 1.5 moa and so on).

Make sure you download the image and display it full screen
in order for everything to line up correctly. Definitely
don't just use the image preview that is displayed in your
browser for calibration. The math might not work out right
if you try that.

# Notes

In order to be able to distinctly see the pixels through
your scope, you will probably need an IOTA (indoor optical
training aid) or similar device. You can create one by just
cutting a circular hole in a piece of cardboard with an
aperture of about one inch and tape it to your scope if you
don't have an IOTA.

If you move closer to or away from the display, you'll want
to recalibrate and use the image that corresponds to the
number of pixels which one mil subtends at that new
position.

vim:tw=60:
