class Cell
{
   int state; //0 dead, 1 alive
  
  void switchState()
  {
    if(isDead())
      born();
    else if(isAlive())
      die();
  }
  
  void die()
  {
    state = 0;
  }
  
  void born()
  {
    state = 1;
  }
  
  boolean isAlive()
  {
    if ( state == 1)
      return true;
    return false;
  }
  
  boolean isDead()
  {
    return ! isAlive();
  }
}