import math
import numpy as np

class MDP_StateSpace:

    def __init__(self, box_count:int, reward_function:function = (lambda x: 0)) -> None:
        self.box_count = box_count
        self.reward_function = reward_function


    def is_a_box(pot_box_number:int):
        return True

    def moving_reward(self, box_number_1:int, box_number_2:int) -> float:
        # return the reward of moving from one box to the other
        return reward_function(box_number_1, box_number_2)



class MDimCuboidStateSpace(MDP_StateSpace):
    # Class for a multidimensional cuboidal State space, which can be partitioned in cuboidal boxes

    def __init__(self, lower_bounds: list[float], upper_bounds:list[float], MD_box_count:list[int], reward_function:function = (lambda x: 0)) -> None:
        if ((len(lower_bounds) != len(upper_bounds)) | (len(upper_bounds) != MD_box_count)):
            raise RuntimeError("Input arrays are of different lengths")
        elif(not all([[lower_bound < upper_bound for lower_bound in lower_bounds] for upper_bound in upper_bounds])):
            raise RuntimeError("Array Bounds are defective")
        else:
            super(math.multiply(MD_box_count), reward_function).__init__()
            self.dim = len(MD_box_count)
            self.lower_bounds = lower_bounds
            self.upper_bounds = upper_bounds
            self.MD_box_count = MD_box_count
            self.box_count = math.multiply(MD_box_count)
            self.box_sizes = np.zeros(len(MD_box_count))
            for i in range(0, self.dim):
                self.box_sizes[i] = (upper_bounds[i] - lower_bounds[i]) / MD_box_count[i]


    @property
    def dim(self):
        return self.dim


    @property
    def box_size(self):
        return self.box_sizes


    def coordinate_to_box_array(self, coordinate:list[float]) -> list[float]:
        # returns the multidimensional (array) box number of the given coordinate point, boxes are closed towards the lower boundry

        return box_array


    def coordinate_to_box_number(self, coordinate:list[float]) -> int:
        #gives a uniqe integer identifier of the box

        return box_number


    def box_number_to_box_lower_boundry(self, box_number:int) -> list[float]:
        return lower_boundry

    
    def box_number_to_box_upper_boundry(self, box_number:int) -> list[float]:
        return upper_boundry


    def uniform_sample_point_in_box(self, box_number:int, seed = 69) -> list[float]:
        return coordinate


    def is_coordinate_in_box(self, coordinate:list[float], box_number:int) -> bool:
        return True

