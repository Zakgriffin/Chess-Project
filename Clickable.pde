class Clickable {
  PVector center;
  float sizeX, sizeY;
  boolean held = false;
  
  Clickable(PVector v, float w, float h) {
    center = v;
    sizeX = w;
    sizeY = h;
  }
  
  boolean isHovered() {
    return abs(center.x - mouseX) < sizeX / 2 && 
           abs(center.y - mouseY) < sizeY / 2;
  }
  
  boolean isPressed() {
    boolean r = isHovered() && mousePressed;
    if(!r) held = false;
    return r;
  }
  
  boolean isClicked() {
    boolean r = isPressed() && !held;
    if(r) held = true;
    return r;
  }
  
  void show() {
    //rectMode(CENTER);
    rect(center.x, center.y, sizeX, sizeY);
  }
}
