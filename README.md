This smart contract utilizes chainlink's VRF. An NBA team is successfully selected in a provably random way from a chainlink VRF when the generateRandomNumber function is called on the source contract. A random integer is generated, and then a modulo of 10 is used to make the integer a random number between 0 and 9. Then based on the random number generated, a random NBA team is selected that has been preassigned to the numbers. 

USE CASE- This could be a provably random way to select team seeding, playoff home court advantages, or draft lottery positions- therefore eliminating the possibility of rigging these events.

Pretty epic.