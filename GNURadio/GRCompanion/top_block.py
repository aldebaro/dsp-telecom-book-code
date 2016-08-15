#!/usr/bin/env python
##################################################
# Gnuradio Python Flow Graph
# Title: Top Block
# Generated: Sun Nov 10 06:29:39 2013
##################################################

from PyQt4 import Qt
from gnuradio import blocks
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.gr import firdes
from gnuradio.qtgui import qtgui
from grc_gnuradio import blks2 as grc_blks2
from math import sqrt, sin, pi
from optparse import OptionParser
import numpy
import sip
import sys

class top_block(gr.top_block, Qt.QWidget):

	def __init__(self):
		gr.top_block.__init__(self, "Top Block")
		Qt.QWidget.__init__(self)
		self.setWindowTitle("Top Block")
		self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
		self.top_scroll_layout = Qt.QVBoxLayout()
		self.setLayout(self.top_scroll_layout)
		self.top_scroll = Qt.QScrollArea()
		self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
		self.top_scroll_layout.addWidget(self.top_scroll)
		self.top_scroll.setWidgetResizable(True)
		self.top_widget = Qt.QWidget()
		self.top_scroll.setWidget(self.top_widget)
		self.top_layout = Qt.QVBoxLayout(self.top_widget)
		self.top_grid_layout = Qt.QGridLayout()
		self.top_layout.addLayout(self.top_grid_layout)


		##################################################
		# Variables
		##################################################
		self.snr_db = snr_db = 3
		self.noiseAmplitude = noiseAmplitude = sqrt(1/(10**(0.1*snr_db)))
		self.constellation = constellation = [-1.3416,   -0.4472,    0.4472,    1.3416]
		self.bits = bits = 2

		##################################################
		# Blocks
		##################################################
		self.random_source_x_0 = gr.vector_source_b(map(int, numpy.random.randint(0, 4, 10000)), True)
		self.qtgui_sink_x_0_0_1 = qtgui.sink_c(
			1024, #fftsize
			firdes.WIN_BLACKMAN_hARRIS, #wintype
			0, #fc
			400, #bw
			"QT GUI Plot", #name
			False, #plotfreq
			False, #plotwaterfall
			False, #plottime
			True, #plotconst
		)
		self.qtgui_sink_x_0_0_1.set_update_time(1.0 / 100)
		self._qtgui_sink_x_0_0_1_win = sip.wrapinstance(self.qtgui_sink_x_0_0_1.pyqwidget(), Qt.QWidget)
		self.top_layout.addWidget(self._qtgui_sink_x_0_0_1_win)
		self.gr_tag_debug_0 = gr.tag_debug(gr.sizeof_float*1, "")
		self.gr_noise_source_x_0 = gr.noise_source_f(gr.GR_GAUSSIAN, noiseAmplitude, 0)
		self.gr_file_sink_1 = gr.file_sink(gr.sizeof_gr_complex*1, "symbols.bin")
		self.gr_file_sink_1.set_unbuffered(False)
		self.gr_file_sink_0_0 = gr.file_sink(gr.sizeof_char*1, "output.bin")
		self.gr_file_sink_0_0.set_unbuffered(False)
		self.gr_file_sink_0 = gr.file_sink(gr.sizeof_char*1, "input.bin")
		self.gr_file_sink_0.set_unbuffered(False)
		self.digital_constellation_decoder_cb_0 = digital.constellation_decoder_cb(digital.constellation_calcdist([-3,-1,1,3], [], 1, 1).base())
		self.digital_chunks_to_symbols_xx_0 = digital.chunks_to_symbols_bf((constellation), 1)
		self.const_source_x_0 = gr.sig_source_f(0, gr.GR_CONST_WAVE, 0, 0, 0)
		self.blocks_throttle_0 = blocks.throttle(gr.sizeof_float*1, 100)
		self.blocks_float_to_complex_0 = blocks.float_to_complex(1)
		self.blocks_add_xx_0 = blocks.add_vff(1)
		self.blks2_error_rate_0 = grc_blks2.error_rate(
			type='BER',
			win_size=10000,
			bits_per_symbol=bits,
		)

		##################################################
		# Connections
		##################################################
		self.connect((self.random_source_x_0, 0), (self.blks2_error_rate_0, 0))
		self.connect((self.random_source_x_0, 0), (self.digital_chunks_to_symbols_xx_0, 0))
		self.connect((self.gr_noise_source_x_0, 0), (self.blocks_add_xx_0, 1))
		self.connect((self.digital_constellation_decoder_cb_0, 0), (self.blks2_error_rate_0, 1))
		self.connect((self.random_source_x_0, 0), (self.gr_file_sink_0, 0))
		self.connect((self.digital_constellation_decoder_cb_0, 0), (self.gr_file_sink_0_0, 0))
		self.connect((self.blocks_throttle_0, 0), (self.blocks_float_to_complex_0, 0))
		self.connect((self.blocks_float_to_complex_0, 0), (self.digital_constellation_decoder_cb_0, 0))
		self.connect((self.const_source_x_0, 0), (self.blocks_float_to_complex_0, 1))
		self.connect((self.blocks_add_xx_0, 0), (self.blocks_throttle_0, 0))
		self.connect((self.digital_chunks_to_symbols_xx_0, 0), (self.blocks_add_xx_0, 0))
		self.connect((self.blocks_float_to_complex_0, 0), (self.qtgui_sink_x_0_0_1, 0))
		self.connect((self.blocks_float_to_complex_0, 0), (self.gr_file_sink_1, 0))
		self.connect((self.blks2_error_rate_0, 0), (self.gr_tag_debug_0, 0))


	def get_snr_db(self):
		return self.snr_db

	def set_snr_db(self, snr_db):
		self.snr_db = snr_db
		self.set_noiseAmplitude(sqrt(1/(10**(0.1*self.snr_db))))

	def get_noiseAmplitude(self):
		return self.noiseAmplitude

	def set_noiseAmplitude(self, noiseAmplitude):
		self.noiseAmplitude = noiseAmplitude
		self.gr_noise_source_x_0.set_amplitude(self.noiseAmplitude)

	def get_constellation(self):
		return self.constellation

	def set_constellation(self, constellation):
		self.constellation = constellation

	def get_bits(self):
		return self.bits

	def set_bits(self, bits):
		self.bits = bits

if __name__ == '__main__':
	parser = OptionParser(option_class=eng_option, usage="%prog: [options]")
	(options, args) = parser.parse_args()
	qapp = Qt.QApplication(sys.argv)
	tb = top_block()
	tb.start()
	tb.show()
	qapp.exec_()
	tb.stop()

