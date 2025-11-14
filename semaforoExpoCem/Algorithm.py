from serialRead import *

while True:
    print(getLightsState(serialRead(serialPort=openSerialPort())))