# SpaceShooter
SpaceShooter is a chicken invaders-style arcade game made for iOS and focuses on Game Scene and regular ViewController implementation, 
as well as a first project to have its own Assets. The project goes through everything from layout to game physics like collision boxes and explosion effects. 

The entire game scene is implemented programatically through ViewControllers and uses SpriteKit as a main library for the nodes and game objects.
For the assets, I went with a classic arcade-looking background, a spaceship, missile and meteorites made by me in a third party app. 

As stated, the main library is SpriteKit, as it is a great library for game development and implementation of objects. Furthermore, I used CoreMotion to add 
an acceleromtere-based functionality in the movement of the spaceship. 

Declaration of the PhysicsCategories is made for further use in the definition of interactions between the game objects. There are 4 categories I went with:
None
Player
Missile
Meteorite

It can also be declared as enum, since I won't be adding any other members or methods.
I declared the game state as preGame, inGame and endGame. 

For the motion manager I created a constant of type CMMotionManager that I will call when fetching accelerometer data.
Furthermore, the Labels necessary to show game information are declared as type SKLabelNode where I useda font called "moonhouse" for design.

The initializer is a custom one that overrides the required one, using the CGSize type for initialization. 

Now for the accelerometerdata, I implemented the startAccelerometerData() function, that fetches movement data if the accelerometer is available.
In here I implemented the player's movement based on positive or negative accelerometer data and made it so, that the player switches sides of the game scene if
it reaches outside of the playzone. 

In the didMove() function, I initialized and customized all of the Nodes in order and finally added them to the view by calling the addChild() method. 

Next are the functionalities of the game, defined by all the methods that change the variables shown in the labels.

When running out of lives, the gameOver method removes all Nodes from the view and changes the scene to the GameOverScene file. For memory management I also stop the 
accelerometer-fetchinng method. Also, the acceleromter will only start after the current game state has been changed to inGame. 

Levels are implemented with a switchCase based on spawn duration of the meteorites, ranging from 2 second intervals down to 0.6. 

The function for spawning meteorites is especially interesting becuase I used the built in random function to define start and end points for the trajectory of the meteorites. 
After being destroyed or leaving the view bounds, the node is destroyed for efficient memory management. 

Small and very minimalistic explosion effects are made using another asset, which has a basic animation of fade in, scale in and fade out. 

Now for the interactions between the Physics Categories, I implemented the didBegin(_ contact: SKPhysicsContact) method, where, based on the value of the Categories,
the game looks for collisions between said nodes. For each type of interactions I created methods that animate or do something according to the game logic. 



For storing the highScore I used UserDefaults, even though they are best used for in game settings. 
But, as there are no settings in the app, I decided to go with UserDefaults, as it is faster and easier to implement. 
