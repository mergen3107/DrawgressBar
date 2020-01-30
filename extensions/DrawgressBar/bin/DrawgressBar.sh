#!/mnt/us/extensions/DrawgressBar/bin/bash2


#############
# PREAMBULA #
############# 
	# DrawgressBar, v 1.87 (01/29/2020)
	# Author: @mergen3107 on 4pda.ru and mobileread.com forums
	# Discussion thread: https://www.mobileread.com/forums/showthread.php?t=314423
	# A simple and straight-forward KUAL extension to draw progress bar with current progress, chapter marks and subchapter marks during reading.
	# All pieces of code used in this project are obtained through open-source projects (cited where possible), by a search, or common knowledge.
	# Please use, distribute and modify with respect. For personal use only!
	# All sources are freely available.
	# (A proper open-source licensing is yet to come when I properly read about it, sorry for now :D)
	# Device(s) used for development and testing: Kindle PW3 (5.9.7); ...


###########
# CREDITS #
########### 
	# 1) "Progress bar idea" itself is inspired by Kindle 4.1.3 and older, and by JBPatch by @ixtab (https://www.mobileread.com/forums/showthread.php?t=175512)
	# 2) PageTurn actions are /implemented/ by Showtime extension by @Hanspeter (https://www.mobileread.com/forums/showthread.php?t=282590)
	# 3) "bash2" is a renamed "bash 4.2" binary compiled for Kindle by @fbdev (https://www.mobileread.com/forums/showthread.php?t=145738), 
	# from GNU sources (http://ftp.gnu.org/gnu/bash/)
	# 4) eips commands were revealed and explained by @geekmaster (https://www.mobileread.com/forums/showthread.php?t=177564)
	# 5) eips colors discovered by @EternalCyclist (https://www.mobileread.com/forums/showthread.php?t=195980)


################
# INSTALLATION #
################ 
	# As usual for a KUAL-extension: copy the DrawgressBar extension directory to /mnt/us/extensions/ folder (accessible from visible USB storage)
	# Required packages to install: Python3 by NiJule (https://www.mobileread.com/forums/showthread.php?t=225030), ...


#########
# USAGE #
######### 
	# 1) Open a book, where you wish to have progress bar.
	# 2) Edit DrawgressBar.sh: Input the book length, minimum location steps, chapters and subchapter locations into the "PART 1" down below.
	# 	 The units are preferably "locations" (they exist on almost every book), or "pages" if you are lucky to have such.
	#	 (and also change the screen dimensions)
	# 3) Close the book, run DrawgressBar from KUAL.
	# 4) Open the book to start reading. The progress bar /should/ appear at the bottom of the screen.
	# 5) (Optionally, change the progress bar dimensions in the beginning of "PART 2")

#TODO: put Preambula parts into a separate Readme.txt file...


###############################
# PART 1: REQUIRED INPUT INFO #
############################### 

# Chapters, subchapters locations, book info
	# the book length, in the units of "locations" (hence, just "locations"):
	v_locmax=40840

	# location steps of 1 page turn ("locations"), might be 2-3 different values.
	# Obtained by a visual observation during page turns. Depends on the current font type and size, and on presence/size of the images on a page.
	v_locstep=(10 12)

	# chapter "locations" from ToC, if any
#TODO: check whether chapter and subchapter array are non-empty. If they are, draw the progressbar only from page 1 to $v_locmax
	v_chap=(20 39 12372 24665 40474 40514 40800 40810)

	# subchapter "locations" from ToC, if any
	v_subch=(42 888 1501 2247 3153 4566 5860 7889 9258 10690 12375 13776 15328 16637 17838 19082 20302 21654 22513 23198 24668 26424 28529 30116 31603 33434 34680 37252 39132 39821)


####################################
# PART 2: PRELIMINARY CALCULATIONS #
####################################

# Screen dimensions
#TODO: fetch screen sizes automatically from device
	# device-specific screen-dimensions (not necessarily the same as the advertised pixel dimensions):
	SCREEN_X_RES=1088 # "useful" width, in px 
	SCREEN_Y_RES=1448 # 
	
	# desired progress bar dimensions:
	scale_width=0.70 # the ratio of desired progress bar width w.r.t screen width
	scale_height=0.02 # the ratio of of desired progress bar height w.r.t ITS width
	scale_off_y=0.005 # the vertical offset from the bottom of the screen

# Calculate all necessary dimensions:
	# (relative) box width of the progressbar for drawing
	scale_width=$(echo $scale_width| awk '{printf("%.0f\n", $1*100)}')
	box_width="$(($scale_width * ${SCREEN_X_RES} / 100))" # in px
echo box_width $box_width	
	
	# (relative) box height of the progressbar for drawing
	scale_height=$(echo $scale_height| awk '{printf("%.0f\n", $1*100)}')
	box_height="$(($scale_height * ${box_width} / 100))" # in px
echo box_height $box_height
	
	# (absolute) the start point (offset) of the progressbar box
	locstart="$(( (${SCREEN_X_RES} - ${box_width})/2 ))" # in px 	
echo locstart $locstart
	
	# (absolute) the end point (offset) of the progressbar box
	locend="$(($locstart + $box_width))" # in px
echo locend $locend
	
	# (absolute) y-axis offset of the progressbar box from the bottom of the screen
	scale_off_y=$(echo $scale_off_y| awk '{printf("%.0f\n", $1*100)}')
	off_y="$(($scale_off_y * $SCREEN_Y_RES / 100))" # in px
echo off_y $off_y



#### NOT USED SO FAR, BUT PLANNED INITIALLY:
	# scale_chap=1.00 # the ratio of the chapter marks' height w.r.t progressbar height
	# scale_subch=0.75 # the same as $scale_chap, but for subchapter marks
	
	# # (relative) the height of the chapters marks (larger)
	# scale_chap=$(echo $scale_chap| awk '{printf("%.0f\n", $1*100)}')
	# h_chap="$(($scale_chap * $box_height / 100))" # px
# echo h_chap $h_chap

	# # (relative) the height of the subchapters marks (smaller)
	# scale_subch=$(echo $scale_subch| awk '{printf("%.0f\n", $1*100)}')
	# h_subch="$(($scale_subch * $box_height / 100 ))" # px
# echo h_subch $h_subch




# Get current book name
#TODO:  Fetch previous bookname and compare at the script start. If the book is the same, then following calculations are alreade done in the past. E.g.,
# bookname_prev="/mnt/us/documents/Андрей Курышев - Откровение Инсайдера.azw2"
# if [ "$bookname_now" == "$bookname_now2" ]; then
	# echo "This book was processed in the past. Skipping the calculation part..."
	# else
	# echo "A new book for this script. Calculation all necessary dimensions..."
# fi
#TODO: save $bookname_now to a file, along with book number, date opened, etc (just for logging)

	# Fetching the full path to the last opened book
	bookname_now="$(sqlite3 /var/local/cc.db 'SELECT p_location FROM Entries WHERE p_location NOT NULL AND p_cdeType IN ("EBOK", "PDOC") AND p_mimeType IN ("application/x-mobipocket-ebook", "application/x-mobi8-ebook", "application/x-kfx-ebook") AND p_type!="Entry:Item:Dictionary" ORDER BY p_lastAccess DESC LIMIT 1;')";
# (side notes) other possible useful columns from cc.db: p_credits_0_name_collation (author name), p_titles_0_nominal (book name)


# Calculate the absolute pixel coordinates for drawing

	# Location steps (for page turn estimates)
	# The mean of locations step values, $v_locstep:
	sum=0
	sum_total=0
	for i in "${v_locstep[@]}"; do
		sum=`expr $sum + $i`
		sum_total=`expr $sum_total + 1`
	done
	v_locstep="$(($sum / $sum_total))" # mean value of location steps
echo v_locstep $v_locstep # the page step, in locations
	# convert it to absolute pixel coordinates for drawing:
	python_line="locstep = (${v_locstep}/${v_locmax})*${box_width}; print(locstep)"
	locstep=$(python3 -c "${python_line}") 
echo locstep px $locstep	
echo v_locmax $v_locmax
	
	# This is the absolute pixel coordinate of one location step, to draw on the progress bar.
	# The value is typically very small, e.g. 0.1 px, but its precise value is important:
	# just keep adding it to the current location, $locnow_px (obtained at the start of the script),
	# so the script can draw one more pixel in the progress bar, once the value gets to the next nearest integer of $locnow_px (in px)
	
	# Convert Chapter points from $v_chap: from locations to pixel coordinates for drawing
	chap=() # a new temporary array of converted (sub)chapters
	ii=0 # index for $chap
	for i in "${v_chap[@]}"; do
		python_line="div = $locstart + $i/${v_locmax}*${box_width}; print('{:.2f}'.format(div))" # calculate the absolute pixel value
		div=$(python3 -c "${python_line}")
		chap[ii]=$div # add it to the new array
		ii=$ii+1
	done	
echo "${chap[@]}"

	# The same loop as above, but for subchapters
	subch=()
	ii=0
	for i in "${v_subch[@]}"; do
		python_line="div = $locstart + $i/${v_locmax}*${box_width}; print('{:.2f}'.format(div))"
		div=$(python3 -c "${python_line}")
		subch[ii]=$div
		ii=$ii+1
	done	
echo "${subch[@]}"	
	
	
# Get current reading position in the book.
# This is the first current position obtained from cc.db
# Other positions for drawing are obtained via the estimate of page turn locations step, $locstep, described above
	# current finished percent of the last opened book (from cc.db):
	locnow_percent="$(sqlite3 /var/local/cc.db 'SELECT p_percentFinished FROM Entries WHERE p_location NOT NULL AND p_cdeType IN ("EBOK", "PDOC") AND p_mimeType IN ("application/x-mobipocket-ebook", "application/x-mobi8-ebook", "application/x-kfx-ebook") AND p_type!="Entry:Item:Dictionary" ORDER BY p_lastAccess DESC LIMIT 1;')";
	locnow_percent=$(echo $locnow_percent| awk '{printf("%.0f\n", $1*100)}') # multiply decimal by 100 
	# with this, convert it to locations to pixel coordinate for drawing:
	locnow_px="$(($locstart + ${locnow_percent}*${box_width}/10000))" 
echo locnow_percent $locnow_percent
echo locnow_px ${locnow_px}


###################
# PART 3: DRAWING #
###################
	# Finally, DRAW THE PROGRESS BAR

#TODO: find awk event for "book open":
	# ON BOOK OPEN: draw the initial state at $locnow
	# draw_book_open()

#TODO: distinguish page forward, page backward events:
# ON EVERY PAGE TURN: calculate $locnow = $locnow + N*$locstep, where N is the (cumulative) number of page turns
	# draw_page_turn()
	# locnow=$(($locnow + $locstep)) # if page turned forward
	# locnow=$(($locnow - $locstep)) # if page turned backward	
	
	
	
	# for drawing rectangles:
	# eips -d l=a,w=b,h=c [-x xx -y yy -w wf]
	# l is color in hex (colors are found from "eips -i c". 0 is the darkest, ff is the lightest)
	
	# Y-axis coordinates for different parts. Additional integer offset are obtained imperically 
	top_max="$(($SCREEN_Y_RES - $off_y - $box_height - 2))"     	# y-axis coordinate for many things
	top_max2="$(($SCREEN_Y_RES - $off_y - $box_height/2 - 2))" 		# y-axis coordinate for subchapter dots
	
	# The total sum of the following two widths should be equal to $locend - $locstart (i.e. the total relative progress bar width, in px):
	width_bg_dark="$(($locnow_px - $locstart))"						# width of the finished part
	width_bg_light="$(($locend - locnow_px))"						# width of the part left. 
		
	# # TRIAL-1
	# &> /var/log/messages && 2>/dev/null tail -F /var/log/messages | exec parselog | \
	# awk '/.*PageTurnAction*./ || /.*JunoExecutionManager*./  {system("eips -d l=0,w=${width_bg_dark},h=${box_height} -x ${locstart} -y ${top_max}")}'

	# # TRIAL-2
	# tail -F /var/log/messages 2>/dev/null | exec /usr/bin/parselog | awk '/.*PageAction*./  {system("eips -d l=0,w=${width_bg_dark},h=${box_height} -x ${locstart} -y ${top_max}")}  '
	
	# Draw once manually for now...
	eips -d l=0,w=$width_bg_dark,h=$box_height -x $locstart -y $top_max  # draw dark gray background (progress)
	eips -d l=70,w=$width_bg_light,h=$box_height -x $locnow_px -y $top_max  # draw light gray background (amount left)
	
	# draw Chapters
	for i in "${chap[@]}"; do 
		eips -d l=ff,w=2,h=$box_height -x $i -y $top_max  # draw dark gray progress
	done 
	
	# draw Subchapters	 
	for i in "${subch[@]}"; do 
		eips -d l=ff,w=1,h=2 -x $i -y $top_max2   # draw dark gray progress
	done

# to be continued...
