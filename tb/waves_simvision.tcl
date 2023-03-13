# SimVision Command Script (Sex Mar 10 17:16:50 -03 2023)
#
# Version 20.03.s003
#
# You can restore this configuration with:
#
#     simvision -input /prj/xmen2/joao.gomes/AXI4-Lite-VIP/tb/waves_simvision.tcl
#  or simvision -input /prj/xmen2/joao.gomes/AXI4-Lite-VIP/tb/waves_simvision.tcl database1 database2 ...
#


#
# Preferences
#
preferences set txe-locate-add-fibers 1
preferences set signal-type-colors {assertion #FF0000 output #FFA500 group #0099FF inout #00FFFF input #FFFF00 fiber #00EEEE errorsignal #FF0000 unknown #FFFFFF overlay #0099FF internal #00FF00 reference #FFFFFF}
preferences set seq-time-width 30
preferences set txe-navigate-search-locate 0
preferences set txe-view-hold 0
preferences set expand-attributes data
preferences set plugin-enable-svdatabrowser-new 1
preferences set dynarray-height 10
preferences set verilog-colors {Su #ff0099 0 {} 1 {} HiZ #ff9900 We #00ffff Pu #9900ff Sm #00ff99 X #ff0000 StrX #ff0000 other #ffff00 Z #ff9900 Me #0000ff La #ff00ff St {}}
preferences set txe-navigate-waveform-locate 1
preferences set txe-view-hidden 0
preferences set waveform-height 20
preferences set toolbar-Standard-Console {
  usual
  position -pos 1
}
preferences set txe-search-show-linenumbers 1
preferences set toolbar-Search-Console {
  usual
  position -pos 2
}
preferences set toolbar-txe_waveform_toggle-WaveWindow {
  usual
  position -pos 1
}
preferences set plugin-enable-groupscope 0
preferences set key-bindings {Edit>Undo Ctrl+z PageUp PageUp View>Zoom>Next {Alt+Right arrow} View>Zoom>In Alt+i PageDown PageDown Edit>Copy Ctrl+c ScrollDown {Down arrow} Edit>Create>Group Ctrl+g View>Zoom>FullY_widget y Simulation>NextInScope F7 Edit>Select>All Ctrl+a Format>Radix>Decimal Ctrl+Shift+D Edit>Ungroup Ctrl+Shift+G TopOfPage Home Edit>Create>Condition Ctrl+e {command -console SimVision {%w sidebar access designbrowser selectall}} Alt+a ScrollLeft {Left arrow} Edit>SelectAllText Alt+a Edit>TextSearchConsole Alt+s View>Zoom>FullX_widget = Windows>SendTo>Waveform Ctrl+w Simulation>Return Shift+F5 View>CallstackDown {Ctrl+Down arrow} Select>All Ctrl+a Edit>Delete Del Format>Radix>Octal Ctrl+Shift+O Edit>Cut Ctrl+x Simulation>Run F2 Edit>Create>Marker Ctrl+m View>Center Alt+c View>CallstackInWindow Ctrl+k Edit>SelectAll Ctrl+a File>OpenDatabase Ctrl+o Edit>Redo Ctrl+y Format>Radix>Binary Ctrl+Shift+B View>ExpandSequenceTime>AtCursor Alt+x ScrollUp {Up arrow} File>CloseWindow Ctrl+Shift+w ScrollRight {Right arrow} View>Zoom>FullX Alt+= Edit>Create>Bus Ctrl+b Explore>NextEdge Ctrl+\] View>Zoom>Cursor-Baseline Alt+z View>Zoom>OutX Alt+o Edit>GoToLine Ctrl+g View>Zoom>Fit Alt+= View>Zoom>OutX_widget o View>CallstackUp {Ctrl+Up arrow} View>Bookmarks>Add Ctrl+b View>ShowValues Ctrl+s Simulation>Next F6 Edit>Search Ctrl+f Format>Radix>Hexadecimal Ctrl+Shift+H Edit>Create>MarkerAtCursor Ctrl+Shift+M View>Zoom>InX Alt+i View>Zoom>Out Alt+o Edit>TextSearch Ctrl+f View>Zoom>Previous {Alt+Left arrow} Edit>Paste Ctrl+v Format>Signed Ctrl+Shift+S View>CollapseSequenceTime>AtCursor Alt+s View>Zoom>InX_widget i Format>Radix>ASCII Ctrl+Shift+A Simulation>Step F5 Explore>PreviousEdge {Ctrl+[} BottomOfPage End}
preferences set plugin-enable-interleaveandcompare 0
preferences set plugin-enable-waveformfrequencyplot 0
preferences set toolbar-Windows-WaveWindow {
  usual
  position -pos 2
}
preferences set txe-navigate-waveform-next-child 1
preferences set waveform-space 4
preferences set vhdl-colors {H #00ffff L #00ffff 0 {} X #ff0000 - {} 1 {} U #9900ff Z #ff9900 W #ff0000}
preferences set txe-locate-scroll-x 1
preferences set txe-locate-scroll-y 1
preferences set transaction-height 6
preferences set txe-locate-pop-waveform 1

#
# PPE data
#
array set dbNames ""
set dbNames(realName1) [database require waves -hints {
	file ./waves.shm/waves-3.trn
	file /prj/xmen2/joao.gomes/AXI4-Lite-VIP/tb/waves.shm/waves-3.trn
}]

#
# Conditions
#
set expression {((((top.a4_lite_in.clk === 'b1) && (shift(top.a4_lite_in.clk, 10 ns) === 'b0)) && ((top.a4_lite_in.awready === 'b1) && (top.a4_lite_in.awvalid === 'b1))) ? 'b1 : 'b0)}
if {[catch {condition new -name  handshake_wr_addr -expr $expression}] != ""} {
    condition set -using handshake_wr_addr -expr $expression
}
set expression {((((top.a4_lite_in.clk === 'b1) && (shift(top.a4_lite_in.clk, 10 ns) === 'b0)) && ((top.a4_lite_in.arready === 'b1) && (top.a4_lite_in.awvalid === 'b1))) ? 'b1 : 'b0)}
if {[catch {condition new -name  teste -expr $expression}] != ""} {
    condition set -using teste -expr $expression
}
set expression {((((top.a4_lite_in.clk === 'b1) && (shift(top.a4_lite_in.clk, 10 ns) === 'b0)) && ((top.a4_lite_in.wready === 'b1) && (top.a4_lite_in.wvalid === 'b1))) ? 'b1 : 'b0)}
if {[catch {condition new -name  wr_data_handshake -expr $expression}] != ""} {
    condition set -using wr_data_handshake -expr $expression
}
set expression {((((top.a4_lite_in.clk === 'b1) && (shift(top.a4_lite_in.clk, 10 ns) === 'b0)) && ((top.a4_lite_in.bready === 'b1) && (top.a4_lite_in.bvalid === 'b1))) ? 'b1 : 'b0)}
if {[catch {condition new -name  wr_resp_handshake -expr $expression}] != ""} {
    condition set -using wr_resp_handshake -expr $expression
}

#
# Mnemonic Maps
#
mmap new  -reuse -name {Boolean as Logic} -radix %b -contents {{%c=FALSE -edgepriority 1 -shape low}
{%c=TRUE -edgepriority 1 -shape high}}
mmap new  -reuse -name {Example Map} -radix %x -contents {{%b=11???? -bgcolor orange -label REG:%x -linecolor yellow -shape bus}
{%x=1F -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=2C -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=* -label %x -linecolor gray -shape bus}}

#
# Design Browser windows
#
if {[catch {window new WatchList -name "Design Browser 1" -geometry 730x500+261+33}] != ""} {
    window geometry "Design Browser 1" 730x500+261+33
}
window target "Design Browser 1" on
browser using {Design Browser 1}
browser set -scope [subst  {$dbNames(realName1)::[format {top.a4_lite_in}]} ]
browser set \
    -signalsort name
browser yview see [subst  {$dbNames(realName1)::[format {top.a4_lite_in}]} ]
browser timecontrol set -lock 0

#
# Waveform windows
#
if {[catch {window new WaveWindow -name "Waveform 1" -geometry 1920x1097+-1+27}] != ""} {
    window geometry "Waveform 1" 1920x1097+-1+27
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar select designbrowser
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units ns \
    -valuewidth 75
waveform baseline set -time 30ns

set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.arst_n}]}
	} ]]
waveform format $id -color #ffffff
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.clk}]}
	} ]]
waveform format $id -color #ffffff
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.awaddr[31:0]}]}
	} ]]
waveform format $id -color #00ff99
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.awprot[2:0]}]}
	} ]]
waveform format $id -color #00ff99
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.awready}]}
	} ]]
waveform format $id -color #ff9900
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.awvalid}]}
	} ]]
waveform format $id -color #00ff99
set id [waveform add -signals [subst  {
	{[format {handshake_wr_addr}]}
	} ]]
waveform format $id -color #ff00ff
waveform hierarchy collapse $id
set id [waveform add -cdivider divider]
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.wdata[31:0]}]}
	} ]]
waveform format $id -color #00ff99
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.wvalid}]}
	} ]]
waveform format $id -color #00ff99
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.wready}]}
	} ]]
waveform format $id -color #ff9900
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.wstrb[3:0]}]}
	} ]]
waveform format $id -color #00ff99
set id [waveform add -signals [subst  {
	{[format {wr_data_handshake}]}
	} ]]
waveform format $id -color #ff00ff
set id [waveform add -cdivider divider]
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.bready}]}
	} ]]
waveform format $id -color #00ff99
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.bresp[2:0]}]}
	} ]]
waveform format $id -color #ff9900
set id [waveform add -signals [subst  {
	{$dbNames(realName1)::[format {top.a4_lite_in.bvalid}]}
	} ]]
waveform format $id -color #ff9900
set id [waveform add -signals [subst  {
	{[format {wr_resp_handshake}]}
	} ]]
waveform format $id -color #ff00ff

waveform xview limits 0 264ns

#
# Waveform Window Links
#

#
# Console windows
#
console set -windowname Console
window geometry Console 730x250+261+564

#
# Layout selection
#
