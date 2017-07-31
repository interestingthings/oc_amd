#!/bin/bash
export DISPLAY=:0

if [ -z "$1" ] || [ -z "$2" ] ||  [ -z "$3" ]
	then
	echo "Missing variable"
	exit 1
fi

# getting number of gpu
gpu_number=`lspci | grep VGA | grep ATI | wc -l`
# splitting OC values devided by comma into arrays
IFS=', ' read -r -a core_clk <<< "$1"
IFS=', ' read -r -a memo_clk <<< "$2"
IFS=', ' read -r -a powr_lvl <<< "$3"

# checking user input for power setting
function check_pwr {
	local power=$1
	if [[ $power -lt "-20" ]]; then
		power="-20"
	elif [[ $power -gt "20" ]]; then
		power=20
	else
		:
	fi
	echo $power
}

# checking number of parameters from user input
function check_param {
	declare -n array=$1
	if [ ${#array[@]} -ge $gpu_number ]; then
		# Already ok
		:
	elif [ ${#array[@]} -eq 1 ]; then
		# Using first for all
		for (( i = 1; i < $gpu_number; i++ )); do
			array+=(${array[0]})
		done
	else
		# If number of parameters less then gpu's number, use last for rest.
		for (( i = $gpu_number - ${#array[@]}; i < $gpu_number ; i++ )); do
			array+=(${array[-1]})
		done
	fi
}

check_param core_clk
check_param memo_clk
check_param powr_lvl

amdconfig --od-enable --adapter=all
for (( i = 0; i < $gpu_number; i++ )); do
	powertune=$(check_pwr ${powr_lvl[$i]})
	echo "Applying CoreClock: ${core_clk[$i]} MemoryClock ${memo_clk[$i]} for GPU:$i"
	amdconfig --od-setclocks=${core_clk[$i]},${memo_clk[$i]} --adapter=$i &
	#echo "Applying PowerTune Level $powertune for GPU:$i"
	/root/utils/atitweak/atitweak -p $powertune --adapter=$i &
	sleep 0.2
done
