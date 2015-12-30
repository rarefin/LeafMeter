package pointCalculator;

import java.util.ArrayList;

import matrix.Matrix;

public class AngleCalculator {
	ArrayList<Point> arr = new ArrayList<>();
	
	public int getAngle(Matrix matrix){
		getpoints(matrix);
		
		DistanceCalculator dc = new DistanceCalculator();
		double d = dc.calcTan(arr);

		return (int) Math.toDegrees(d);
	}

	private void getpoints(Matrix matrix) {

		int a = 0;
		for (int i = 0; i < matrix.getRow(); i++) {
			for (int j = 0; j < matrix.getCol(); j++) {
				int[] array = matrix.getPixel(i, j);
				
				if (Math.abs(array[0]-array[1]) < 3 && Math.abs(array[0]-array[2]) < 3) {

				} else {
					Point p = new Point(i, j);
					arr.add(p);
					a = 1;
					break;
				}
			}

			if (a == 1)
				break;
		}

		a = 0;

		for (int i = matrix.getRow() - 1; i >= 0; i--) {
			for (int j = 0; j < matrix.getCol(); j++) {
				int[] array = matrix.getPixel(i, j);
				
				if (Math.abs(array[0]-array[1]) < 3 && Math.abs(array[0]-array[2]) < 3) {

				} else {
					Point p = new Point(i, j);
					arr.add(p);
					a = 1;
					break;
				}
			}

			if (a == 1)
				break;
		}

		a = 0;

		for (int i = 0; i < matrix.getCol(); i++) {
			for (int j = 0; j < matrix.getRow(); j++) {
				int[] array = matrix.getPixel(j, i);
				
				if (Math.abs(array[0]-array[1]) < 3 && Math.abs(array[0]-array[2]) < 3) {

				} else {
					Point p = new Point(i, j);
					arr.add(p);
					a = 1;
					break;
				}
			}

			if (a == 1)
				break;
		}

		a = 0;

		for (int i = matrix.getCol() - 1; i >= 0; i--) {
			for (int j = 0; j < matrix.getRow(); j++) {
				int[] array = matrix.getPixel(j, i);
				
				if (Math.abs(array[0]-array[1]) < 3 && Math.abs(array[0]-array[2]) < 3) {

				} else {
					Point p = new Point(i, j);
					arr.add(p);
					a = 1;
					break;
				}
			}

			if (a == 1)
				break;
		}
	}
}
