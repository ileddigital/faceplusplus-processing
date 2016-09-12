import httprocessing.*;
import processing.video.*;


Capture cam;
PImage photo; 
int photoAge; 

String api_key = "fbdd84ed5fab78b1384f943cf5fd3e69";
String api_secret = "7IpVkigS2UeSnDYWGhD3XDTAKdMyeffb";

String jonImg = "/Users/jrogers/Documents/Processing/faceplusplus_with_cam/data/jon.jpg";
String photoImg = "/Users/jrogers/Documents/Processing/faceplusplus_with_cam/data/camPhoto.jpg";




PostRequest post; 

public void setup() 
{
 size(640,360); 
 // size(1280,720); 
  
  photo = loadImage(jonImg); 
  //set up camera
  
  //CAMERA SETUP
  String[] cameras = Capture.list();
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    // cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
     println(cameras[3]);
    cam = new Capture(this, cameras[3]); // 15 when usb cam on (or check other) - testing with FT cam - fps 1? cam  
    //cam = new Capture(this, 1280, 960);
    cam.start();  

  }
  
  // POST set up
  post = new PostRequest("https://apius.faceplusplus.com/v2/detection/detect");

  post.addData("api_key", api_key);
  post.addData("api_secret", api_secret);
  
  // I needed full path to the image file since relative wasn't working for PostRequest library.
  // Obviously, with the camera you will need to save the PImage as a File before doing this.
  // Also note, you can call post.addFile with the second argument being a Java File object, if that's easier.
 // post.addFile("img", "/Users/mikehenrty/Documents/Processing/simple_json_POST_forFace__base64/data/jon.jpg");
  post.addFile("img", jonImg);
 
  post.send();
  println(post.getContent());

  JSONObject response = parseJSONObject(post.getContent());
  JSONArray face = response.getJSONArray("face");
  JSONObject attribute = face.getJSONObject(0);
  JSONObject at2 = attribute.getJSONObject("attribute");
  JSONObject age = at2.getJSONObject("age");
  println ("Welcome Jon your age is..." + age.getInt("value"));
  photoAge = age.getInt("value"); 
  println ("photo age = " + photoAge); 
  
  println ("starting draw"); 

}

void draw()
{
  // show current saved image
  //image(photo, 0,0); 
 
     if (cam.available()) {
     cam.read();
     image(cam, 0, 0); 
   }
  
  fill(200,30,30);
  textSize(60);
  text(photoAge, 330, 100); 
  

  
}



// ------------------------ KEY PRESSED ----------------

void keyReleased() {
  // in mirror code this will be the mat being stepped on.. . 
  
  // take a picture 
  
     image(cam, 0, 0); 
     PImage screengrab = createImage(width, height, ALPHA);
     save(photoImg); 

  // post it 
   post = new PostRequest("https://apius.faceplusplus.com/v2/detection/detect");

  post.addData("api_key", api_key);
  post.addData("api_secret", api_secret);
  
  // I needed full path to the image file since relative wasn't working for PostRequest library.
  // Obviously, with the camera you will need to save the PImage as a File before doing this.
  // Also note, you can call post.addFile with the second argument being a Java File object, if that's easier.
 // post.addFile("img", "/Users/mikehenrty/Documents/Processing/simple_json_POST_forFace__base64/data/jon.jpg");
 
  
  post.addFile("img", photoImg);
 
  post.send();
  
  
  println(post.getContent());
  
  
  JSONObject response = parseJSONObject(post.getContent());
  try{
  JSONArray face = response.getJSONArray("face");
  JSONObject attribute = face.getJSONObject(0);
  JSONObject at2 = attribute.getJSONObject("attribute");
  JSONObject age = at2.getJSONObject("age");
  println ("Welcome Jon your age is..." + age.getInt("value"));
  
  photoAge = age.getInt("value");
  } catch (Exception e)
 
  { 
    e.printStackTrace();
    println("sorry, couldnt' find your age"); 
  }
  
  // set age. 
  
  // would be nicer to have in a set of functions - but the void keyReleased forces this rough hack... will do for now.. 
   
  
}