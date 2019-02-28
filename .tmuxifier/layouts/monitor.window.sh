new_window "monitor"

split_h 50

run_cmd "htop" 0
run_cmd "ctop" 1

select_pane 0
