import tkinter as tk
from tkinter import ttk
import maquinaDeEstados
import serial

# Global variables for vehicle counts
vehicles_north = 0
vehicles_south = 0
vehicles_west = 0
vehicles_east = 0
pedestrians = 0

current_state = 0
state_timer = 10
emergencia = False
prioridad0_flag = False
prioridad1_flag = False
prioridad2_flag = False
prioridad3_flag = False
prioridad4_flag = False

# Initialize serial port
ser = serial.Serial('/dev/ttyACM1', 9600)


def set_prioridad0():
    global prioridad0_flag
    prioridad0_flag = True


def set_prioridad1():
    global prioridad1_flag
    prioridad1_flag = True


def set_prioridad2():
    global prioridad2_flag
    prioridad2_flag = True


def set_prioridad3():
    global prioridad3_flag
    prioridad3_flag = True


def set_prioridad4():
    global prioridad4_flag
    prioridad4_flag = True


def check_prioridad():
    global prioridad0_flag, prioridad1_flag, prioridad2_flag, prioridad3_flag, prioridad4_flag, current_state
    if prioridad0_flag and current_state == 0:
        prioridad0_flag = False
    elif prioridad1_flag and current_state == 5:
        prioridad1_flag = False
    elif prioridad2_flag and current_state == 10:
        prioridad2_flag = False
    elif prioridad3_flag and current_state == 15:
        prioridad3_flag = False
    elif prioridad4_flag and (current_state == 8 or current_state == 18):
        prioridad4_flag = False


def reiniciar_semaforo():
    global current_state, state_timer, emergencia, prioridad0_flag, prioridad1_flag, prioridad2_flag, prioridad3_flag, prioridad4_flag
    current_state = 0
    state_timer = 10
    emergencia = False
    prioridad0_flag = False
    prioridad1_flag = False
    prioridad2_flag = False
    prioridad3_flag = False
    prioridad4_flag = False


def set_emergency():
    global emergencia
    emergencia = True


def run_lights():
    global current_state, state_timer, emergencia, prioridad0_flag, prioridad1_flag, prioridad2_flag, prioridad3_flag, prioridad4_flag
    current_state, state_timer = maquinaDeEstados.get_next_state(current_state, state_timer, prioridad0_flag,
                                                                 prioridad1_flag, prioridad2_flag, prioridad3_flag,
                                                                 prioridad4_flag, emergencia)
    check_prioridad()
    ser.write(f"{current_state}\n".encode())
    print(current_state)
    root.after(1000, run_lights)


# Create main window
root = tk.Tk()
root.title("Control de flujo vehicular")
root.geometry("400x300")

# Create and configure grid
root.grid_columnconfigure(1, weight=1)
root.grid_columnconfigure(2, weight=0)

# Create instructions label
label = ttk.Label(root, text="Indicar prioridad, reinicio, y modo de emergencia")
label.grid(row=0, column=0, columnspan=3, padx=5, pady=5)

prioridad0_button = ttk.Button(root, text="Prioridad para semaforo direccion norte", command=set_prioridad0)
prioridad0_button.grid(row=1, column=0, padx=5, pady=5)

prioridad1_button = ttk.Button(root, text="Prioridad para semaforo direccion sur", command=set_prioridad1)
prioridad1_button.grid(row=1, column=1, padx=5, pady=5)

prioridad2_button = ttk.Button(root, text="Prioridad para semaforo direccion este", command=set_prioridad2)
prioridad2_button.grid(row=1, column=2, padx=5, pady=5)

prioridad3_button = ttk.Button(root, text="Prioridad para semaforo direccion oeste", command=set_prioridad3)
prioridad3_button.grid(row=1, column=3, padx=5, pady=5)

prioridad4_button = ttk.Button(root, text="Prioridad para semaforo peatonal", command=set_prioridad4)
prioridad4_button.grid(row=1, column=4, padx=5, pady=5)

emergency_button = ttk.Button(root, text="Emergencia", command=set_emergency)
emergency_button.grid(row=6, column=0, padx=5, pady=20)

reset_button = ttk.Button(root, text="Reiniciar", command=reiniciar_semaforo)
reset_button.grid(row=6, column=1, padx=5, pady=20)

cancel_button = ttk.Button(root, text="Salir", command=root.destroy)
cancel_button.grid(row=6, column=2, padx=5, pady=20)

root.after(0, run_lights)

# Start main loop
root.mainloop()
