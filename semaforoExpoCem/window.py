import tkinter as tk
from tkinter import messagebox
from serialRead import *

def on_ok():
    user_text = entry.get()
    messagebox.showinfo("Input Received", f"You typed: {user_text}")

def on_cancel():
    root.destroy()

def sendCommand(command):
    ser = openSerialPort()
    ser.write(command.encode())
    closeSerialPort(ser)

def updateInfoOnDisplay():
    ser = openSerialPort()
    state = getLightsState(serialRead(ser))
    label.config(text=state)
    closeSerialPort(ser)
    root.after(1000, updateInfoOnDisplay)

def update_time():
    # Get current time
    current_time = time.strftime("%H:%M:%S")
    # Update label text
    label.config(text=current_time)
    # Schedule the function to run again after 1000 ms (1 second)
    root.after(1000, update_time)

# Create main window
root = tk.Tk()
root.title("Lights Controller")

# Add a label
label = tk.Label(root, text="No data recieved yet")
label.pack(pady=10)

# Add an entry box
entry = tk.Entry(root, width=30)
entry.pack(pady=5)

# Add buttons
ok_button = tk.Button(root, text="OK", command=on_ok)
ok_button.pack(side=tk.LEFT, padx=20, pady=20)

cancel_button = tk.Button(root, text="Cerrar", command=on_cancel)
cancel_button.pack(side=tk.RIGHT, padx=20, pady=20)

#Run loop
updateInfoOnDisplay()

# Run the application
root.mainloop()
