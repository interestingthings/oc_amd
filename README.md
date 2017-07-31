# oc_amd
Small and simple ocerclocking script for AMD GPU ( R series ) to replace default SimpleMiningsOS method.

## Installation
Connect to you mining rig (directly or via ssh).

Install git

`sudo apt install git-core`

Clone repository:

`git clone https://github.com/kusayuzayushko/oc_amd.git`

Copy script into /root/utils directory

`sudo cp oc_amd/oc_amd_r.sh /root/utils`

Make it executable 

`sudo chmod +x /root/utils/oc_amd_r.sh`

Use

`sudo /root/utils/oc_amd_r.sh <core,core> <mem,mem> <power,power>`

If you want to replase default SMOS method, edit /root/xminer.sh file. Change this section

```
echo "============ OVERCLOCKING ================="
if [ $osSeries == "R" ]; then
    amdconfig --od-enable --adapter=all
    amdconfig --od-setclocks=$MINER_CORE,$MINER_MEMORY --adapter=all &
    /root/utils/atitweak/atitweak -p $MINER_POWERLIMIT --adapter=all &
fi
```

to

```
echo "============ OVERCLOCKING ================="
if [ $osSeries == "R" ]; then
    sudo /root/utils/oc_amd_r.sh $MINER_CORE $MINER_MEMORY $MINER_POWERLIMIT
#    amdconfig --od-enable --adapter=all
#    amdconfig --od-setclocks=$MINER_CORE,$MINER_MEMORY --adapter=all &
#    /root/utils/atitweak/atitweak -p $MINER_POWERLIMIT --adapter=all &
fi

```

## Please, report all bugs here or contact cryptoscum in http://chat.simplemining.net/channel/general if you need help or have any questions.
