Advaith Somula


Read ME


Overview :
 WOLF-SAR is a bio-inspired simulation tool designed for optimizing search and rescue (SAR) operations. It leverages the Rapidly-exploring Random Tree (RRT) algorithm, mimicking the hunting strategies of wolf packs to efficiently locate objectives in diverse environments.  


Getting Started:  
To run the WOLF-SAR simulation, ensure you have a compatible MATLAB environment is set up with the necessary dependencies installed.  




Usage:  
The main_results function is the entry point for running simulations. To execute a simulation, use the following command in your MATLAB console:  

```main_results('Terrain_Level', Step_Size)```
	 
Replace 'Terrain_Level' with the desired complexity level ('A', 'B', or 'C') and Step_Size with the numeric value representing the movement increment of the wolves (search agents). 


 
Parameters wolves_positions: 


Initial positions of the wolves (search agents), defined as a cell array of coordinates [x, y]. 
prey: Coordinates of the target [x, y]. 
Iterations: Number of iterations the simulation will run. Each iteration represents a time step in the simulation. 
Configuration  Before running the simulation, configure the parameters to fit the specifics of your SAR scenario.  Setting Wolves' Positions Adjust the wolves' starting positions based on the expected search area and entry points. For example, in the code, the position of wolves are:  


```wolves_positions = {[10, 10]; [9, 11]; [8, 10]; [8, 8]; [9, 7]; [7, 6]; [6, 5]}; ```
	

Setting Prey Position Define the last known position of the objective or missing entity:
 
``` prey = [195, 80]; ```
	

Setting Iterations Determine the total number of iterations based on the complexity of the search area and the desired thoroughness of the search: 


 ``` iterations = 3500; ```


Running a Simulation:
  
To start the simulation, use the command with your specified parameters:


 ```main_results('B', 10);```

Note: Depending on the location oof the wolves and prey you need to adjust the number of iterations.
