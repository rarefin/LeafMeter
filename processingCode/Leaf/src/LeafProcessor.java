import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

import rafi.AngleCalculator;

import matrix.Matrix;
import matrix.MatrixUtil;

public class LeafProcessor {
	private long goodPixel;
	private long totalPixel;
	private long workingPixel;
	private long badPixel;
	private long veryBadPixel;
	private long worstPixel;
	private Matrix matrix;
	
	LeafProcessor(String filePath) throws Exception{
		goodPixel = 0;
		totalPixel = 0;
		workingPixel = 0;
		badPixel = 0;
		veryBadPixel = 0;
		worstPixel = 0;
		matrix = new Matrix(filePath);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	
	public void trimImage() throws Exception{
		int angle = new AngleCalculator().getAngle(matrix);
		if(angle<0){
			angle = -angle - 90;
		}else{
			angle = 90 - angle;
		}
//		System.out.println(angle);
		
//		matrix = MatrixUtil.rotate(matrix, angle);
		matrix = MatrixUtil.cropEdge(matrix);
		
		//matrix.write("C:\\Users\\admin\\Desktop\\a1.png");
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	
	public void processLeaf(){
		long rows = matrix.getRow();
		long cols = matrix.getCol();
		
		totalPixel = rows*cols;
		for(int row=0, col; row<rows; row++){
			for(col=0; col<cols; col++){
				processPixel(matrix.getPixel(row, col));
			}
		}
		
		
		//matrix.write("C:\\Users\\admin\\Desktop\\1.png");
		
		return ;
	}
	
	private void processPixel(int[] pixel){
		
		if(pixel[0]==pixel[1] && pixel[2]==pixel[1]){
			if(pixel[0] >= 240){
				totalPixel--;
			}
		}else {
			if(pixel[0]<180 && pixel[1]>140 && pixel[2]<180){
				if(pixel[0]+pixel[2] < 1.5*pixel[1]){
					goodPixel++;
				}
			}
			
			if(pixel[0]>pixel[1] || pixel[2]>pixel[1]){
				badPixel++;
			}
			
			if(pixel[0] > pixel[1]+15){
				veryBadPixel++;
			}
			
			if(pixel[0] > pixel[1]+50){
				worstPixel++;
			}
			
			workingPixel++;
		}
		
		return ;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////
	
	public void output() throws Exception{
		int imgValidity = (int) ((goodPixel*100)/workingPixel);
		int badRatio = (int) ((badPixel*100)/workingPixel);
		int veryBadRation = (int) ((veryBadPixel*100)/workingPixel);
		int worstRation = (int) ((worstPixel*100)/workingPixel);
		
		int typeOfDeficiency = 0;
		if((veryBadRation*100/badRatio) < 10){
			typeOfDeficiency = 1;	//nitrogen
		}else if((worstRation*100/badRatio) > 5){
			typeOfDeficiency = 2;	//iron
		}else{
			typeOfDeficiency = 3;
		}
		
//		System.out.println(imgValidity);
//		System.out.println(badRatio);
//		System.out.println(veryBadRation);

		BufferedWriter mainBW = new BufferedWriter(new FileWriter("E:\\Duits\\imgProc\\output\\a.txt"));
		mainBW.write(imgValidity + " " + badRatio + " " + typeOfDeficiency);
		mainBW.close();
		
		return ;
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	public static void main(String[] args) {
		try {
			LeafProcessor leafProcessor = new LeafProcessor(new File("E:\\Duits\\imgProc\\input").listFiles()[0].getAbsolutePath());
			leafProcessor.trimImage();
			leafProcessor.processLeaf();
			leafProcessor.output();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
