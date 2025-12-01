import pygame
import random

class WaitingPoint:
    def __init__(self, x, y, allowed_paths, can_go=True):
        """
        Initialize a waiting point where cars must stop.
        
        Args:
            x, y: Position of the waiting point
            allowed_paths: List of path identifiers that must stop here
            can_go: Boolean indicating if cars can proceed
        """
        self.x = x
        self.y = y
        self.allowed_paths = allowed_paths
        self.can_go = can_go
        self.detection_radius = 50  # Distance at which cars detect this waiting point
    
    def set_can_go(self, value):
        """Set whether cars can proceed through this waiting point."""
        self.can_go = value
    
    def should_stop(self, car):
        """Check if a car should stop at this waiting point."""
        if car.path_id not in self.allowed_paths:
            return False
        
        # Calculate distance to waiting point
        dx = self.x - car.x
        dy = self.y - car.y
        distance = (dx**2 + dy**2)**0.5
        
        # Car should stop if it's close and signal is red
        return distance < self.detection_radius and not self.can_go


class Car:
    def __init__(self, x, y, color, path, path_id, size=30, speed=2):
        """
        Initialize a car.
        
        Args:
            x, y: Starting position
            color: RGB tuple for car color
            path: List of (x, y) waypoints the car should follow
            path_id: Identifier for the path (used by waiting points)
            size: Size of the square representing the car
            speed: Movement speed in pixels per frame
        """
        self.x = x
        self.y = y
        self.color = color
        self.path = path.copy()
        self.path_id = path_id
        self.size = size
        self.speed = speed
        self.current_waypoint = 0
        self.stopped = False
        
    def check_collision_with_car(self, other_car, safety_distance=40):
        """Check if this car is too close to another car."""
        if other_car is self:
            return False
        
        dx = other_car.x - self.x
        dy = other_car.y - self.y
        distance = (dx**2 + dy**2)**0.5
        
        return distance < safety_distance
    
    def should_stop_for_waiting_point(self, waiting_points):
        """Check if car should stop at any waiting point."""
        for wp in waiting_points:
            if wp.should_stop(self):
                return True
        return False
    
    def should_stop_for_cars(self, other_cars):
        """Check if car should stop to avoid collision."""
        # Only check cars ahead in the movement direction
        if self.current_waypoint >= len(self.path):
            return False
        
        target_x, target_y = self.path[self.current_waypoint]
        dx = target_x - self.x
        dy = target_y - self.y
        
        for other_car in other_cars:
            if self.check_collision_with_car(other_car):
                # Check if the other car is ahead of us
                other_dx = other_car.x - self.x
                other_dy = other_car.y - self.y
                
                # Dot product to see if other car is in our direction
                dot_product = dx * other_dx + dy * other_dy
                if dot_product > 0:  # Other car is ahead
                    return True
        return False

    def update(self, waiting_points=None, other_cars=None):
        """
        Move the car along its path.
        
        Args:
            waiting_points: List of WaitingPoint objects
            other_cars: List of other Car objects to avoid
        """
        if self.current_waypoint >= len(self.path):
            return False  # Car has completed its path
        
        # Check if car should stop
        stop_for_waiting = False
        stop_for_collision = False
        
        if waiting_points:
            stop_for_waiting = self.should_stop_for_waiting_point(waiting_points)
        
        if other_cars:
            stop_for_collision = self.should_stop_for_cars(other_cars)
        
        self.stopped = stop_for_waiting or stop_for_collision
        
        if self.stopped:
            return True  # Car is still active but stopped
        
        target_x, target_y = self.path[self.current_waypoint]
        
        # Calculate direction to target
        dx = target_x - self.x
        dy = target_y - self.y
        distance = (dx**2 + dy**2)**0.5
        
        if distance < self.speed:
            # Reached waypoint, move to next
            self.x, self.y = target_x, target_y
            self.current_waypoint += 1
        else:
            # Move toward waypoint
            self.x += (dx / distance) * self.speed
            self.y += (dy / distance) * self.speed
        
        return True  # Car is still active

    def draw(self, screen):
        """Draw the car as a square."""
        pygame.draw.rect(screen, self.color,
                         (int(self.x - self.size / 2), int(self.y - self.size / 2),
                          self.size, self.size))