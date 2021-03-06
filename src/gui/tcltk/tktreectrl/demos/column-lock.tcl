# Copyright (c) 2006-2011 Tim Baker

namespace eval DemoColumnLock {}

proc DemoColumnLock::Init {T} {

    variable Priv

    InitPics *checked

    #
    # Configure the treectrl widget
    #

    $T configure \
	-showbuttons no \
	-showlines no \
	-showroot no \
	-xscrollincrement 40 -xscrolldelay 50 -xscrollsmoothing yes \
	-yscrollincrement 0 -yscrolldelay 50 -yscrollsmoothing yes

    #
    # Create columns
    #

    for {set i 0} {$i < 100} {incr i} {
	$T column create -text "C$i" -tags C$i -width [expr {40 + 20 * ($i % 2)}] -justify center
    }
    $T column configure first -text LEFT -lock left -width ""
    $T column configure last -text RIGHT -lock right -width ""

    $T item state define CHECK
    $T item state define mouseover

    #
    # Create styles for the left-locked column, and create items
    #

    $T element create label1.bg rect -fill {gray80 mouseover gray {}}
    $T element create label1.text text
    $T style create label1 -orient horizontal
    $T style elements label1 {label1.bg label1.text}
    $T style layout label1 label1.bg -detach yes -iexpand xy
    $T style layout label1 label1.text -expand wns -padx 2

    for {set i 1} {$i <= 10} {incr i} {
	set I [$T item create -tags R$i -parent root]
	$T item style set $I C0 label1
	$T item text $I C0 "R$i"
    }

    $T element create label2.bd border -background $::SystemButtonFace \
	-relief raised -thickness 2 -filled yes
    $T element create label2.text text
    $T style create label2 -orient horizontal
    $T style elements label2 {label2.bd label2.text}
    $T style layout label2 label2.bd -detach yes -iexpand xy
    $T style layout label2 label2.text -expand news -padx 2 -pady 2

    for {set i 11} {$i <= 20} {incr i} {
	set I [$T item create -tags R$i -parent root]
	$T item style set $I C0 label2
	$T item text $I C0 "R$i"
    }

    $T element create label3.div rect -fill black -height 2
    $T element create label3.text text
    $T style create label3 -orient horizontal
    $T style elements label3 {label3.div label3.text}
    $T style layout label3 label3.div -detach yes -expand n -iexpand x
    $T style layout label3 label3.text -expand ws -padx 2 -pady 2

    for {set i 21} {$i <= 30} {incr i} {
	set I [$T item create -tags R$i -parent root]
	$T item style set $I C0 label3
	$T item text $I C0 "R$i"
    }

    $T element create label4.rect rect -fill {#e0e8f0 mouseover}
    $T element create label4.text text
    $T element create label4.w window -clip yes -destroy yes
    $T style create label4 -orient vertical
    $T style elements label4 {label4.rect label4.text label4.w}
    $T style layout label4 label4.rect -detach yes -iexpand xy
    $T style layout label4 label4.text -expand we -padx 2 -pady 2
    $T style layout label4 label4.w -iexpand x -padx 2 -pady {0 2}

    for {set i 31} {$i <= 40} {incr i} {
	set I [$T item create -tags R$i -parent root]
	$T item style set $I C0 label4
	$T item element configure $I C0 label4.text -textvariable ::DemoColumnLock::Priv(R$i)
	set clip [frame $T.clipR${I}C0 -borderwidth 0]
	$::entryCmd $clip.e -width 4 -textvariable ::DemoColumnLock::Priv(R$i)
	$T item element configure $I C0 label4.w -window $clip
	set Priv(R$i) "R$i"
    }

    #
    # Create styles for the right-locked column
    #

    $T element create labelR1.bg rect -fill {gray80 mouseover gray {}}
    $T element create labelR1.img image -image {checked CHECK unchecked {}}
    $T style create labelR1 -orient horizontal
    $T style elements labelR1 {labelR1.bg labelR1.img}
    $T style layout labelR1 labelR1.bg -detach yes -iexpand xy
    $T style layout labelR1 labelR1.img -expand news -padx 2 -pady 2

    $T element create labelR2.bd border -background $::SystemButtonFace \
	-relief raised -thickness 2 -filled yes
    $T element create labelR2.img image -image {checked CHECK unchecked {}}
    $T style create labelR2 -orient horizontal
    $T style elements labelR2 {labelR2.bd labelR2.img}
    $T style layout labelR2 labelR2.bd -detach yes -iexpand xy
    $T style layout labelR2 labelR2.img -expand news -padx 2 -pady 2

    $T element create labelR3.div rect -fill black -height 2
    $T element create labelR3.img image -image {checked CHECK unchecked {}}
    $T style create labelR3 -orient horizontal
    $T style elements labelR3 {labelR3.div labelR3.img}
    $T style layout labelR3 labelR3.div -detach yes -expand n -iexpand x
    $T style layout labelR3 labelR3.img -expand news -padx 2 -pady 2

    $T element create labelR4.rect rect -fill {#e0e8f0 mouseover}
    $T element create labelR4.img image -image {checked CHECK unchecked {}}
    $T style create labelR4 -orient vertical
    $T style elements labelR4 {labelR4.rect labelR4.img}
    $T style layout labelR4 labelR4.rect -detach yes -iexpand xy
    $T style layout labelR4 labelR4.img -expand news -padx 2 -pady 2

    $T item style set {range R1 R10} last labelR1
    $T item style set {range R11 R20} last labelR2
    $T item style set {range R21 R30} last labelR3
    $T item style set {range R31 R40} last labelR4

    #
    # Create styles for the non-locked columns
    #

    $T item state define selN
    $T item state define selS
    $T item state define selW
    $T item state define selE

    $T element create cell.bd rect -outline gray -outlinewidth 1 -open wn \
	-fill {gray80 mouseover #F7F7F7 CHECK}
    set fill [list gray !focus $::SystemHighlight {}]
    $T element create cell.selN rect -height 2 -fill $fill
    $T element create cell.selS rect -height 2 -fill $fill
    $T element create cell.selW rect -width 2 -fill $fill
    $T element create cell.selE rect -width 2 -fill $fill
    $T style create cell -orient horizontal
    $T style elements cell {cell.bd cell.selN cell.selS cell.selW cell.selE}
    $T style layout cell cell.bd -detach yes -iexpand xy
    $T style layout cell cell.selN -detach yes -expand s -iexpand x -draw {no !selN}
    $T style layout cell cell.selS -detach yes -expand n -iexpand x -draw {no !selS}
    $T style layout cell cell.selW -detach yes -expand e -iexpand y -draw {no !selW}
    $T style layout cell cell.selE -detach yes -expand w -iexpand y -draw {no !selE}

    # NOTE 1: the following column descriptions are equivalent in this demo:
    #   "range {first next} {last prev}"
    #   "all lock none" (see note #2 below)
    #   "lock none !tail"
    # The above item descriptions all specify the unlocked columns between
    # the left-locked and right-locked columns.

    $T item style set "root children" "range {first next} {last prev}" cell

    $T element create windowStyle.rect rect -fill {#e0e8f0 mouseover #F7F7F7 CHECK}
    $T element create windowStyle.text text
    $T element create windowStyle.window window -clip yes -destroy yes
    $T style create windowStyle -orient vertical
    $T style elements windowStyle {windowStyle.rect windowStyle.text windowStyle.window}
    $T style layout windowStyle windowStyle.rect -detach yes -iexpand xy
    $T style layout windowStyle windowStyle.text -expand we -padx 2 -pady 2
    $T style layout windowStyle windowStyle.window -iexpand x -padx 2 -pady {0 2}

    # NOTE 2: "all lock none" also matches the tail column, however the
    # [item style set] command does not operate on the tail column so it is
    # ignored. Explicitly naming the tail column would result in an error
    # however. Another example of this behaviour is [column delete all].

    $T item style set "list {R2 R22}" "all lock none" windowStyle

    foreach C [$T column id "lock none !tail"] {
	set Priv(C$C) [$T column cget $C -tags]

	set I R2
	set clip [frame $T.clipR${I}C$C -borderwidth 0]
	$::entryCmd $clip.e -width 4 -textvariable ::DemoColumnLock::Priv(C$C)
	$T item element configure $I $C windowStyle.window -window $clip + \
	    windowStyle.text -textvariable ::DemoColumnLock::Priv(C$C)

	set I R22
	set clip [frame $T.clipR${I}C$C -borderwidth 0]
	$::entryCmd $clip.e -width 4 -textvariable ::DemoColumnLock::Priv(C$C)
	$T item element configure $I $C windowStyle.window -window $clip + \
	    windowStyle.text -textvariable ::DemoColumnLock::Priv(C$C)
    }

    bind DemoColumnLock <ButtonPress-1> {
	DemoColumnLock::Button1 %W %x %y
    }
    bind DemoColumnLock <Button1-Motion> {
	DemoColumnLock::Motion1 %W %x %y
	DemoColumnLock::Motion %W %x %y
    }
    bind DemoColumnLock <Motion> {
	DemoColumnLock::Motion %W %x %y
    }

    set Priv(prev) ""
    set Priv(selection) {}

    bindtags $T [list $T DemoColumnLock TreeCtrl [winfo toplevel $T] all]

    return
}

proc DemoColumnLock::Button1 {w x y} {
    variable Priv
    $w identify -array id $x $y
    set Priv(selecting) 0
    if {$id(where) eq "item"} {
	set item $id(item)
	set column $id(column)
	if {[$w column compare $column == last]} {
	    $w item state set $item ~CHECK
	    return
	}
	if {[$w column cget $column -lock] eq "none"} {
	    set Priv(corner1) [list $item $column]
	    set Priv(corner2) $Priv(corner1)
	    set Priv(selecting) 1
	    UpdateSelection $w
	}
    }
    return
}

proc DemoColumnLock::Motion1 {w x y} {
    variable Priv
    $w identify -array id $x $y
    if {$id(where) eq "item"} {
	set item $id(item)
	set column $id(column)
	if {[$w column cget $column -lock] eq "none"} {
	    if {$Priv(selecting)} {
		set corner [list $item $column]
		if {$corner ne $Priv(corner2)} {
		    set Priv(corner2) $corner
		    UpdateSelection $w
		}
	    }
	}
    }
    return
}

proc DemoColumnLock::Motion {w x y} {
    variable Priv
    $w identify -array id $x $y
    if {$id(where) eq ""} {
	# nothing
    } elseif {$id(where) eq "header"} {
	# nothing
    } elseif {$id(where) eq "item"} {
	set item $id(item)
	set column $id(column)
	set curr [list $item $column]
	if {$curr ne $Priv(prev)} {
	    if {$Priv(prev) ne ""} {
		eval $w item state forcolumn $Priv(prev) !mouseover
	    }
	    $w item state forcolumn $item $column mouseover
	    set Priv(prev) $curr
	}
	return
    }
    if {$Priv(prev) ne ""} {
	eval $w item state forcolumn $Priv(prev) !mouseover
	set Priv(prev) ""
    }
    return
}

proc DemoColumnLock::UpdateSelection {w} {
    variable Priv

    # Clear the old selection.
    foreach {item column} $Priv(selection) {
	$w item state forcolumn $item $column {!selN !selS !selE !selW}
    }
    set Priv(selection) {}

    # Order the 2 corners.
    foreach {item1 column1} $Priv(corner1) {}
    foreach {item2 column2} $Priv(corner2) {}
    if {[$w item compare $item1 > $item2]} {
	set swap $item1
	set item1 $item2
	set item2 $swap
    }
    if {[$w column compare $column1 > $column2]} {
	set swap $column1
	set column1 $column2
	set column2 $swap
    }

    # Set the state of every item-column on the edges of the selection.
    $w item state forcolumn $item1 "range $column1 $column2" selN
    $w item state forcolumn $item2 "range $column1 $column2" selS
    $w item state forcolumn "range $item1 $item2" $column1 selW
    $w item state forcolumn "range $item1 $item2" $column2 selE

    # Remember every item-column on the edges of the selection.
    foreach item [list $item1 $item2] {
	foreach column [$w column id "range $column1 $column2"] {
	    lappend Priv(selection) $item $column
	}
    }
    foreach item [$w item id "range $item1 $item2"] {
	foreach column [list $column1 $column2] {
	    lappend Priv(selection) $item $column
	}
    }
    return
}

proc DemoColumnLock::AddText {} {
    set w [DemoList]
    $w style elements cell {cell.bd label1.text cell.selN cell.selS cell.selW cell.selE}
    $w item text visible {lock none} abc
}
