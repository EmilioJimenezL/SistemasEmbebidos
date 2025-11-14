import serial
import serial.tools.list_ports
import sys
import time


def getLightsState(serialLine):
    match serialLine:
        case "00000":
            return "State 0"
        case "00001":
            return "State 1"
        case "00010":
            return "State 2"
        case "00011":
            return "State 3"
        case "00100":
            return "State 4"
        case "00101":
            return "State 5"
        case "00110":
            return "State 6"
        case "00111":
            return "State 7"
        case "01000":
            return "State 8"
        case "01001":
            return "State 9"
        case "01010":
            return "State 10"
        case "01011":
            return "State 11"
        case "01100":
            return "State 12"
        case "01101":
            return "State 13"
        case "01110":
            return "State 14"
        case "01111":
            return "State 15"
        case "10000":
            return "State 16"
        case "10001":
            return "State 17"
        case "10010":
            return "State 18"
        case "10011":
            return "State 19"
        case "10100":
            return "Emergency"

def openSerialPort(port = "ACM0", baudrate = 9600, timeout = 1):
    fullPort = '/dev/tty' + port
    ser = serial.Serial(fullPort, baudrate, timeout=timeout)
    return ser

def closeSerialPort(ser):
    ser.close()

def serialRead(serialPort, verbose = False):
    data = serialPort.readline().decode('utf-8').strip()
    if verbose:
        print("Data received:" + data)
    return data

def serialWrite(serialPort, command, verbose = False):
    serialPort.write(command.encode())
    if verbose:
        print("Command sent:" + command)