# Xander1998's / NodeJS Database API / FiveM Resource /

## LICENSE [Please read the license before using this.]

<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.

## Requirements
1. NodeJS - https://nodejs.org/en/
2. NPM - https://www.npmjs.com/get-npm
3. MySQL Database

## Installation
1. Find a folder location somewhere you want to install the database api.
2. Open up command prompt.
3. Get the folder location you made previously. ^ Refer to step one's location ^
4. In the command prompt type "cd [paste the folder location here]". ^ You should see the folder location change on the command prompt.
5. In the command prompt type "git clone https://github.com/xander1998/DatabaseAPI.git"
6. In the command prompt type "cd DatabaseAPI".
7. Once that is done installing make sure you have NPM installed and type in the command prompt "npm install"

## IMPORTANT
Find the config.js file and setup your database server port.

MAKE SURE THAT YOU CHANGE THE SECRET. THAT IS THE PASSWORD FOR YOU DATABASE API AUTH TOKEN!!!!

## How  to start the server
1. Make sure you cd into the DatabaseAPI folder in the command prompt.
2. type "node server" and the server will launch

## FiveM Server

If you are using this for a FiveM server. Take the externalsql out of
https://github.com/xander1998/DatabaseAPI/tree/master/%5BFiveM%20Resource%5D
and start and put it in your resources folder then modify the config.lua
