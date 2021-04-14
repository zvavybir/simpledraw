// Copyright 2021 Matthias Kaak
//
// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
// https://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or https://opensource.org/licenses/MIT>, at your
// option. This file may not be copied, modified, or distributed
// except according to those terms.

/// Size of the window; x-coordinate
int size_x = 1800;
/// Size of the window; y-coordinate
int size_y = 1000;

/// Margin at each side for [`draw_points`] in the x direction
float margin_x = 50;
/// Margin at each side for [`draw_points`] in the y direction
float margin_y = 50;

/// The size of the window minus the margin; x-coordinate
float size_minus_margin_x = size_x - 2*margin_x;
/// The size of the window minus the margin; x-coordinate
float size_minus_margin_y = size_y - 2*margin_y;

/// All points that should be drawn
///
/// All points that should be drawn as an array of points.  Since Java
/// doesn't have tuples as far as I know (I'm not a Java programmer, but
/// C/Rust) a point is realised as a array of two elements (using a struct
/// would be more idiomatic, but complicates handling, I think).
///
/// # Exceptions
/// To not provoke OutOfBound-exceptions in other functions you should take
/// care not giving the inner array less than two dimensions since at many
/// points it is unchecked assumed that it has two dimensions.
double[][] all_points;

/// Gets the minimum coordinate for a given dimension
///
/// Gets the minimum coordinate for the dimension in `dim`.  If `dim` is `0`
/// it returns for example the x-coordinate of the leftmost point.  Use `1`
/// if you want to have the y-coordinate.
///
/// # Exceptions
/// It throws a OutOfBound exception if `dim` is bigger than the count of
/// dimensions [`all_points`] has, what usual means if it is bigger than `1`.
double
min_dim(int dim)
{
  int i = 0;
  double min;
  
  if(all_points.length == 0)
  {
    return -1.0;
  }
  min = all_points[0][dim];
  
  for(i = 1; i < all_points.length; i++)
  {
    if(all_points[i][dim] < min)
      min = all_points[i][dim];
  }

  return min;
}

/// Gets the maximum coordinate for a given dimension
///
/// Gets the maximum coordinate for a given dimension; see [`min_dim`]
double
max_dim(int dim)
{
  int i = 0;
  double max;
  
  if(all_points.length == 0)
  {
    return 1.0;
  }
  max = all_points[0][dim];
  
  for(i = 1; i < all_points.length; i++)
  {
    if(all_points[i][dim] > max)
      max = all_points[i][dim];
  }

  return max;
}

/// Draws the points in [`all_points`]
///
/// Draws the points in [`all_points`].  It doesn't draw axes and doesn't
/// clears the background, so you have to do it.
void
draw_points()
{
  int i = 0;
  double min_x = min_dim(0);
  double max_x = max_dim(0);
  double min_y = min_dim(1);
  double max_y = max_dim(1);
  double span_x = max_x - min_x;
  double span_y = max_y - min_y;
  
  for(i = 0; i < all_points.length;  i++)
  {
    float x = (float) ((all_points[i][0] - min_x)/span_x
                        * size_minus_margin_x);
    float y = (float) ((all_points[i][1] - min_y)/span_y
                        * size_minus_margin_y);
    rect(x + margin_x, size_y-(y + margin_y), 2, 2);
  }
}

/// Draws the axes
void
draw_axes()
{
  // Axes
  fill(color(127));
  rect(margin_x/2, size_y-margin_y/2, size_x - margin_y, 1);
  rect(margin_x/2, margin_y/2, 1, size_y - margin_x);
  
  // Labels
  rect(margin_x, size_y-5*margin_y/8, 1, margin_y/4); // x-min
  rect(size_x-margin_x, size_y-5*margin_y/8, 1, margin_y/4); // x-max
  rect(3*margin_x/8, margin_y, margin_x/4, 1); // y-max
  rect(3*margin_x/8, size_y-margin_y, margin_x/4, 1); // y-min
  fill(color(255));
  text((float) min_dim(0), margin_x-26, size_y-margin_y/4);
  text((float) max_dim(0), size_x-margin_x-26, size_y-margin_y/4);
  text((float) max_dim(1), 5, margin_y-3);
  text((float) min_dim(1), 4.9, size_y-margin_y-3);
  //rect();
}

void
setup()
{
  size(1800, 1000);
  noStroke();
  //frameRate(10);
}

void
draw()
{
  make_points();  
  
  background(0);
  draw_axes();
  draw_points();
}

int offset = 0;

/// Makes the points;  EDIT THIS FUNCTION
void
make_points()
{
  int i;
  
  // Reserves array for points
  all_points = new double[384+4][2];
  
  // Calculates points on a circle; because of scaling they will appear
  // as an ellipse.
  for(i = 4; i < 384; i++)
  {
    all_points[i][0] = cos((float) ((i+offset)/64.0)) * 100;
    all_points[i][1] = sin((float) ((i+offset)/64.0)) * 100;
  }offset++;
  
  // Makes some custom points
  all_points[0][0] = 0;
  all_points[0][1] = 0;
  all_points[1][0] = 5;
  all_points[1][1] = 0;
  all_points[2][0] = 0;
  all_points[2][1] = 5;
  all_points[3][0] = mouseX - size_x/2;
  all_points[3][1] = size_y/2 - mouseY;
}
