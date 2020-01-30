

#############
# PREAMBULA #
############# 
	# DrawgressBar, v 1.87 (01/29/2020)\
	# Author: @mergen3107 on 4pda.ru and mobileread.com forums\
	# Discussion thread: https://www.mobileread.com/forums/showthread.php?t=314423\
	# A simple and straight-forward KUAL extension to draw progress bar with current progress, chapter marks and subchapter marks during reading.\
	# All pieces of code used in this project are obtained through open-source projects (cited where possible), by a search, or common knowledge.\
	# Please use, distribute and modify with respect. For personal use only!\
	# All sources are freely available.\
	# (A proper open-source licensing is yet to come when I properly read about it, sorry for now :D)\
	# Device(s) used for development and testing: Kindle PW3 (5.9.7); ...


###########
# CREDITS #
###########
	# 1) "Progress bar idea" itself is inspired by Kindle 4.1.3 and older, and by JBPatch by @ixtab (https://www.mobileread.com/forums/showthread.php?t=175512)\
	# 2) PageTurn actions are /implemented/ by Showtime extension by @Hanspeter (https://www.mobileread.com/forums/showthread.php?t=282590)\
	# 3) "bash2" is a renamed "bash 4.2" binary compiled for Kindle by @fbdev (https://www.mobileread.com/forums/showthread.php?t=145738), \
	# from GNU sources (http://ftp.gnu.org/gnu/bash/)\
	# 4) eips commands were revealed and explained by @geekmaster (https://www.mobileread.com/forums/showthread.php?t=177564)\
	# 5) eips colors discovered by @EternalCyclist (https://www.mobileread.com/forums/showthread.php?t=195980)


################
# INSTALLATION #
################
	# As usual for a KUAL-extension: copy the DrawgressBar extension directory to /mnt/us/extensions/ folder (accessible from visible USB storage)\
	# Required packages to install: Python3 by NiJule (https://www.mobileread.com/forums/showthread.php?t=225030), ...


#########
# USAGE #
######### 
	# 1) Open a book, where you wish to have progress bar.\
	# 2) Edit DrawgressBar.sh: Input the book length, minimum location steps, chapters and subchapter locations into the "PART 1" down below.\
	# 	 The units are preferably "locations" (they exist on almost every book), or "pages" if you are lucky to have such.\
	#	 (and also change the screen dimensions)\
	# 3) Close the book, run DrawgressBar from KUAL.\
	# 4) Open the book to start reading. The progress bar /should/ appear at the bottom of the screen.\
	# 5) (Optionally, change the progress bar dimensions in the beginning of "PART 2")
