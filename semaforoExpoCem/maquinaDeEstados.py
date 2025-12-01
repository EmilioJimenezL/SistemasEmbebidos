def get_next_state(current_state, timer, prioridad0_flag=False, prioridad1_flag=False, prioridad2_flag=False, prioridad3_flag=False, prioridad4_flag=False,
                 emergency_flag=False):
    time = None
    next_state = None
    if emergency_flag:
        return 20, 30
    elif timer == 0:
        if prioridad0_flag and (current_state in [4, 7, 14, 17]):
            next_state = 0
            time = 10
        elif prioridad1_flag and (current_state in [4, 7, 14, 17]):
            next_state = 5
            time = 10
        elif prioridad2_flag and (current_state in [4, 7, 14, 17]):
            next_state = 10
            time = 10
        elif prioridad3_flag and (current_state in [4, 7, 14, 17]):
            next_state = 15
            time = 10
        elif prioridad4_flag and (current_state in [4, 7]):
            next_state = 8
            time = 10
        elif prioridad4_flag and (current_state in [14, 17]):
            next_state = 18
            time = 10
        else:
            match current_state:
                case 0:
                    next_state = 1
                    time = 5
                case 1:
                    next_state = 2
                    time = 10
                case 2:
                    next_state = 3
                    time = 5
                case 3:
                    next_state = 4
                    time = 5
                case 4:
                    next_state = 5
                    time = 10
                case 5:
                    next_state = 6
                    time = 5
                case 6:
                    next_state = 7
                    time = 5
                case 7:
                    next_state = 8
                    time = 10
                case 8:
                    next_state = 9
                    time = 5
                case 9:
                    next_state = 10
                    time = 10
                case 10:
                    next_state = 11
                    time = 5
                case 11:
                    next_state = 12
                    time = 10
                case 12:
                    next_state = 13
                    time = 5
                case 13:
                    next_state = 14
                    time = 5
                case 14:
                    next_state = 15
                    time = 10
                case 15:
                    next_state = 16
                    time = 5
                case 16:
                    next_state = 17
                    time = 5
                case 17:
                    next_state = 18
                    time = 10
                case 18:
                    next_state = 19
                    time = 5
                case 19:
                    next_state = 0
                    time = 10
                case _:
                    next_state = 0
                    time = 10
        return next_state, time
    else:
        timer -= 1
        return current_state, timer