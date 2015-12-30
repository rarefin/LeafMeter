package pointCalculator;

import java.util.ArrayList;

public class DistanceCalculator {
	
	public double calcTan(ArrayList<Point> points) {
		Point p1 = null,p2 = null;
		double max=0;
		
		for(int i=0;i<points.size()-1;i++){
			for(int j=i+1;j<points.size();j++){
				double d = points.get(i).distance(points.get(j));
				if(d>max){
					max=d;
					p1=points.get(i);
					p2=points.get(j);
				}
			}
		}
		
		double abc= (double) (p2.y-p1.y)/(p2.x-p1.x);
		
		return Math.tanh(abc);
	}
	
}
