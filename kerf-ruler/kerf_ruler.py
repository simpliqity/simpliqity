
# Script for generating a PDF file containing a ruler for measuring
# a laser cutter's kerf. Using the same technique as is used on
# Vernier calipers, the kerf can be measured to the scale of 1/100th
# of a mm by finding the pair of lines that most closely line up.
#
# Ideally we'd be using OpenSCAD to generate this, like everything
# else, but OpenSCAD is currently too limited to generate this
# (specifically it lacks the ability to generate 2D lines, and
# to export color for the labels).

import math
import cairo

# A4 paper
PAPER_W = 11.7 * 72
PAPER_H = 8.27 * 72

# Ruler size in mm.
RULER_L = 250
RULER_W = 40

# Size of units on ruler, in mm.
DIVISIONS = 100
STEP_SIZE = 0.01

def outer_ruler(points, interval, line_offset):
	for i in range(points + 1):
		x = i * interval
		ctx.move_to(x, 0)
		ctx.line_to(x, -line_offset)
		ctx.close_path()
		ctx.stroke()

def inner_ruler(points, interval, line_offset):
	for i in range(points + 1):
		if (i % 2) == 0:
			offset = line_offset
			label = "%0.02f" % (i * STEP_SIZE)
		else:
			offset = line_offset * 0.7
			label = ""

		x = i * (interval + STEP_SIZE)
		ctx.move_to(x, 0)
		ctx.line_to(x, offset)
		ctx.close_path()
		ctx.stroke()

		ctx.save()
		ctx.translate(x, line_offset)
		ctx.rotate(math.pi / 2)
		ctx.translate(1, 1)
		ctx.scale(0.3, 0.3)
		ctx.show_text(label)
		ctx.restore()

surface = cairo.PDFSurface("kerf_ruler.pdf", PAPER_W, PAPER_H)
ctx = cairo.Context(surface)

# Adjust scale so that we are working in millimeters
# instead of points of an inch.
ctx.scale(72 / 25.4, 72 / 25.4)

ctx.set_line_width(0.1)
ctx.translate(10, 30)

ctx.rectangle(0, 0, RULER_L, RULER_W)
ctx.stroke()
ctx.rectangle(5, 10, RULER_L - 10, RULER_W - 20)
ctx.stroke()

ctx.set_source_rgb(1, 0, 0)
ctx.translate(10, 10)
interval = (RULER_L - 22.0) / DIVISIONS
outer_ruler(DIVISIONS, interval, 7)
inner_ruler(DIVISIONS, interval, 7)

surface.finish()

