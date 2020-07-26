The guide to coding ScreenGui objects in Roblox Studio using Lua Scripts.
There are many ways to code/create GUIs for plugins in Roblox Studio, this is a guide just for using the ScreenGui object.

Normally to create a ScreenGui object you will have to go to the "StartGui" object in your "Explorer" window and click on the "+" symbol and insert a ScreenGui.
To replicate this in Lua script, we will look at the following line:

  local myscreengui = Instance.new("ScreenGui", game:GetService("CoreGui"))
  
  "myscreengui" is the local variable name, you can change it to whatever you desire.
  The important part here is the "Instance.new()", which is what we will be using a lot to create an object in Roblox Studio.
  Also realize that "Instance.new()" has two arguments.
    The first argument is the type of object you are creating in the form of a strin; in this case it is an object of type ScreenGui.
    The second argument is the parent of the object you are create; if you don't what a parent, use "nil".
    We connect our ScreenGui object to the CoreGui as this allows other users to see and interact with the GUI when they download it.
    
After creating the "ScreenGui" object, you can now create the actual gui parts by using "Instance.new()" and setting the parent of the part as your "ScreenGui" object.

To see all the types of gui parts (such as "TextLabel", "ImageLabel", and "Textbutton") you can create, just create a ScreenGui the normal way (see line 4), and 
press the "+" next to your ScreenGui and see all the gui parts. This is also helpful when trying to see all the attributes of a gui types so you can change them,
aka create it normally and see all the options you can change in the "Explorer" window.
In fact, a way I found helpful is to just create the desired gui design normally, then try to write it up in a Lua script.
