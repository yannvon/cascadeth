
#!/bin/bash
#
# Tests the correctness of the Uniform Reliable Broadcast application.
#
# This is an example script that shows the general structure of the
# test. The details and parameters of the actual test might differ.
#

#time to wait for correct processes to broadcast all messages (in seconds)
#(should be adapted to the number of messages to send)
time_to_finish=5

init_time=2

#configure lossy network simulation
sudo tc qdisc del dev lo root netem delay 50ms 200ms loss 10% 25% reorder 25% 50%


echo "5
1 127.0.0.1 11001
2 127.0.0.1 11002
3 127.0.0.1 11003
4 127.0.0.1 11004
5 127.0.0.1 11005" >> membership

#start 5 processes, each broadcasting 1000 messages
for i in `seq 1 5`
do
    ../src/da_proc $i membership 40  &
    da_proc_id[$i]=$!
done

#leave some time for process initialization
sleep $init_time


#start broadcasting
for i in `seq 1 5`
do
    if [ -n "${da_proc_id[$i]}" ]; then
	kill -USR2 "${da_proc_id[$i]}"
    fi
done

# Leave some time for the correct processes to broadcast all messages
sleep $time_to_finish

#stop all processes
for i in `seq 1 5`
do
    if [ -n "${da_proc_id[$i]}" ]; then
	kill -TERM "${da_proc_id[$i]}"
    fi
done

#wait until all processes stop
for i in `seq 1 5`
do
	wait "${da_proc_id[$i]}"
done


echo "Correctness test done."
sudo tc qdisc del dev lo root netem delay 50ms 200ms loss 10% 25% reorder 25% 50%
