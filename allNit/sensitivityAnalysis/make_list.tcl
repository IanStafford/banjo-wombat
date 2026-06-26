# Create a discretized list from start to end with a fixed number of elements.
# Example: set values [make_discretized_list 0.0 1.0 5]
proc make_list {start end n} {
    if {$n < 2} {
        error "number of elements must be at least 2"
    }

    set step [expr {($end - $start) / double($n - 1)}]
    set values {}

    for {set i 0} {$i < $n} {incr i} {
        lappend values [expr {$start + $step * $i}]
    }

    return $values
}