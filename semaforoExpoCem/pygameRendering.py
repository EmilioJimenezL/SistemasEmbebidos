import pygame
import sys
import random
from simulationUtils import Car, WaitingPoint

# Colors
GRAY = (128, 128, 128)  # Road color
WHITE = (255, 255, 255)  # Crossing lines
YELLOW = (255, 255, 0)  # Center lines
GREEN = (0, 150, 0)
LIGHT_GRAY = (196, 197, 196)
RED = (255, 0, 0)  # Rainbow colors
ORANGE = (255, 127, 0)
BLUE = (0, 0, 255)
INDIGO = (75, 0, 130)
VIOLET = (148, 0, 211)

CAR_COLORS = [RED, ORANGE, YELLOW, BLUE, INDIGO, VIOLET]

def generateCar(width, height, road_width, road_center_x, road_center_y):
    """
    Generate a car at a random spawn point with a predefined path.
    
    Returns:
        Car object with random color and path
    """
    car_size = road_width / 10
    carril_horizontal0 = height / 2 - road_width / 2 + car_size / 2
    carril_horizontal1 = carril_horizontal0 + road_width / 6
    carril_horizontal2 = carril_horizontal1 + road_width / 7
    carril_horizontal5 = height / 2 + road_width / 2 - car_size / 2
    carril_horizontal4 = carril_horizontal5 - road_width / 6
    carril_horizontal3 = carril_horizontal4 - road_width / 7
    carril_vertical0 = road_center_x + car_size*(7/8)
    carril_vertical1 = carril_vertical0 + road_width*(2/9)
    carril_vertical3 = (road_center_x + road_width) - car_size*(7/8)
    carril_vertical2 = carril_vertical3 - road_width*(2/9)

    color = random.choice(CAR_COLORS)
    
    # Define spawn points and their corresponding paths with unique IDs
    path_bottom_to_top = [
        (carril_vertical2, height + 30),
        (carril_vertical2, height // 2),
        (carril_vertical2, -30)
    ]

    path_top_to_bottom = [
        (carril_vertical1, -30),
        (carril_vertical1, height // 2),
        (carril_vertical1, height + 30)
    ]

    path_left_to_right = [
        (-30, carril_horizontal4),
        (width // 2, carril_horizontal4),
        (width + 30, carril_horizontal4)
    ]

    path_right_to_left = [
        (width + 30, carril_horizontal1),
        (width // 2, carril_horizontal1),
        (-30, carril_horizontal1)
    ]
    
    path_left_to_top = [
        (-30, carril_horizontal3),
        (carril_vertical2, carril_horizontal3),
        (carril_vertical2, -30)
    ]
    
    path_left_to_bottom = [
        (-30, carril_horizontal5),
        (carril_vertical0, carril_horizontal5),
        (carril_vertical0, height+30)
    ]
    
    path_right_to_top = [
        (width + 30, carril_horizontal0),
        (carril_vertical3, carril_horizontal0),
        (carril_vertical3, -30)
    ]
    
    path_right_to_bottom = [
        (width + 30, carril_horizontal2),
        (carril_vertical1, carril_horizontal2),
        (carril_vertical1, height+30)
    ]
    
    path_top_to_left = [
        (carril_vertical0, -30),
        (carril_vertical0, carril_horizontal0),
        (-30, carril_horizontal0)
    ]
    path_top_to_right = [
        (carril_vertical1, -30),
        (carril_vertical1, carril_horizontal3),
        (width + 30, carril_horizontal3)
    ]
    path_bottom_to_left = [
        (carril_vertical2, height + 30),
        (carril_vertical2, carril_horizontal2),
        (-30, carril_horizontal2)
    ]
    path_bottom_to_right = [
        (carril_vertical3, height + 30),
        (carril_vertical3, carril_horizontal5),
        (width+30, carril_horizontal5)
    ]

    # Create list of all paths with IDs
    all_paths = [
        ("bottom_to_top", path_bottom_to_top),
        ("top_to_bottom", path_top_to_bottom),
        ("left_to_right", path_left_to_right),
        ("right_to_left", path_right_to_left),
        ("left_to_top", path_left_to_top),
        ("left_to_bottom", path_left_to_bottom),
        ("right_to_top", path_right_to_top),
        ("right_to_bottom", path_right_to_bottom),
        ("top_to_left", path_top_to_left),
        ("top_to_right", path_top_to_right),
        ("bottom_to_left", path_bottom_to_left),
        ("bottom_to_right", path_bottom_to_right)
    ]
    
    # Randomly select a path
    path_id, selected_path = random.choice(all_paths)
    start_x, start_y = selected_path[0]

    return Car(start_x, start_y, color, selected_path, path_id, size=road_width/9, speed=3)


def create_waiting_points(width, height, road_width, road_center_x, road_center_y):
    """
    Create waiting points at the intersection for traffic control.
    
    Returns:
        List of WaitingPoint objects
    """
    car_size = road_width / 10
    
    # Calculate waiting point positions (before the intersection)
    waiting_distance = road_width / 2 + 30
    
    waiting_points = [
        # Vertical paths (from bottom)
        WaitingPoint(
            width // 2, 
            height // 2 + waiting_distance,
            ["bottom_to_top"],
            can_go=True
        ),
        # Vertical paths (from top)
        WaitingPoint(
            width // 2,
            height // 2 - waiting_distance,
            ["top_to_bottom", "top_to_left"],
            can_go=True
        ),
        # Horizontal paths (from left)
        WaitingPoint(
            width // 2 - waiting_distance,
            height // 2,
            ["left_to_right", "left_to_top", "left_to_bottom"],
            can_go=False  # Start with red light
        ),
        # Horizontal paths (from right)
        WaitingPoint(
            width // 2 + waiting_distance,
            height // 2,
            ["right_to_left", "right_to_top", "right_to_bottom"],
            can_go=False  # Start with red light
        ),
    ]
    
    return waiting_points


def simulation():
    """
    Creates a resizable pygame window showing an intersection with traffic control.
    
    Features:
    - Cars spawn and follow predefined paths
    - Waiting points control traffic flow
    - Cars stop to avoid collisions
    - Traffic lights alternate between directions
    """
    pygame.init()
    screen = pygame.display.set_mode((800, 600), pygame.RESIZABLE)
    pygame.display.set_caption("Simulacion en tiempo real")
    clock = pygame.time.Clock()
    running = True

    cars = []
    waiting_points = []
    spawn_timer = 0
    spawn_interval = 60  # Spawn a car every 60 frames (1 second at 60 FPS)
    
    # Traffic light control
    light_timer = 0
    light_duration = 180  # 3 seconds per light phase at 60 FPS
    vertical_light_green = True

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.VIDEORESIZE:
                screen = pygame.display.set_mode((event.w, event.h), pygame.RESIZABLE)
            elif event.type == pygame.KEYDOWN:
                # Press SPACE to manually toggle lights
                if event.key == pygame.K_SPACE:
                    vertical_light_green = not vertical_light_green

        width = screen.get_width()
        height = screen.get_height()
        road_width = width // 4
        main_median_width = road_width // 4
        crossing_median_width = road_width // 8
        pedestrian_crossing_height = width/32
        road_center_x = width // 2 - road_width // 2
        road_center_y = height // 2 - road_width // 2

        # Update waiting points for current screen size
        waiting_points = create_waiting_points(width, height, road_width, road_center_x, road_center_y)
        
        # Update traffic light states
        light_timer += 1
        if light_timer >= light_duration:
            light_timer = 0
            vertical_light_green = not vertical_light_green
        
        # Set waiting point states based on traffic lights
        for wp in waiting_points:
            if any(path in wp.allowed_paths for path in ["bottom_to_top", "top_to_bottom", "top_to_left"]):
                wp.set_can_go(vertical_light_green)
            else:
                wp.set_can_go(not vertical_light_green)

        # Fill background
        screen.fill(GREEN)

        # Draw main road (vertical)
        pygame.draw.rect(screen, GRAY, (road_center_x, 0, road_width, height))
        pygame.draw.rect(screen, GREEN, (road_center_x + road_width*0.375, 0, main_median_width, height))

        # Draw road lines (vertical)
        pygame.draw.rect(screen, YELLOW, (road_center_x+road_width*0.1875-5, 0, 10, height))
        pygame.draw.rect(screen, YELLOW, (road_center_x + road_width * 0.8125 - 5, 0, 10, height))

        # Draw crossing road (horizontal)
        pygame.draw.rect(screen, GRAY, (0, road_center_y, width, road_width))
        pygame.draw.rect(screen, GREEN, (0, road_center_y + road_width*0.4375, width, crossing_median_width))

        # Draw road lines (horizontal)
        pygame.draw.rect(screen, YELLOW, (0,road_center_y+ 0.1458*road_width-6.6667, width, 10))
        pygame.draw.rect(screen, YELLOW, (0,road_center_y + (0.1458 * road_width - 6.6667)*2+10, width, 10))
        pygame.draw.rect(screen, YELLOW, (0,road_center_y + 0.4375*road_width + road_width/8 + (0.1458*road_width - 6.6667), width, 10))
        pygame.draw.rect(screen, YELLOW,
                         (0, road_center_y + 0.4375 * road_width + road_width / 8 + (0.1458 * road_width - 6.6667)*2 + 10,
                          width, 10))

        # Draw pedestrian crossings
        pygame.draw.rect(screen, LIGHT_GRAY, (road_center_x, road_center_y - pedestrian_crossing_height, road_width, pedestrian_crossing_height))
        pygame.draw.rect(screen, LIGHT_GRAY, (road_center_x, road_center_y + road_width, road_width,
                                          pedestrian_crossing_height))
        pygame.draw.rect(screen, LIGHT_GRAY, (road_center_x-pedestrian_crossing_height,(height-road_width)/2, pedestrian_crossing_height,
                                         road_width))
        pygame.draw.rect(screen, LIGHT_GRAY, (road_center_x + road_width, (height - road_width) / 2,
                                         pedestrian_crossing_height,
                                         road_width))

        # Draw center square
        pygame.draw.rect(screen, GRAY, (road_center_x, road_center_y, road_width, road_width))

        # Spawn new cars
        spawn_timer += 1
        if spawn_timer >= spawn_interval:
            spawn_timer = 0
            new_car = generateCar(width, height, road_width, road_center_x, road_center_y)
            cars.append(new_car)

        # Update cars with collision detection and waiting points
        active_cars = []
        for car in cars:
            if car.update(waiting_points=waiting_points, other_cars=cars):
                active_cars.append(car)
        cars = active_cars

        # Draw cars
        for car in cars:
            car.draw(screen)

        # Draw traffic light indicators (optional - for debugging)
        light_color = GREEN if vertical_light_green else RED
        pygame.draw.circle(screen, light_color, (20, 20), 10)
        
        pygame.display.flip()
        clock.tick(60)

    pygame.quit()


if __name__ == "__main__":
    simulation()
