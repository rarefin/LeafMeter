/****************************************************************************************************************
* Developer: Minhas Kamal(BSSE-0509, IIT, DU)																	*
* Date: 10-Mar-2015																								*
****************************************************************************************************************/

package matrix;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

public class Matrix {
	public static int BLACK_WHITE = 1;
	public static int BLACK_WHITE_ALPHA = 2;
	public static int RED_GREEN_BLUE = 3;
	public static int RED_GREEN_BLUE_ALPHA = 4;
	
	
	private int[][][] pixels;
	
	public Matrix( int row, int col, int type){
		this.pixels = new int[row][col][type];
	}
	
	public Matrix(String imageFilePath) throws IOException{
		this(ImageIO.read(new File(imageFilePath)));
	}
	
	public Matrix(BufferedImage bufferedImage){
		this.pixels = bufferedImageToMatrix(bufferedImage).pixels;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public int getRow(){
		return pixels.length;
	}
	
	public int getCol(){
		return pixels[0].length;
	}
	
	public int getType(){
		return pixels[0][0].length;
	}
	
	public int[] getPixel(int row, int col){
		return pixels[row][col].clone();
	}
	
	public void setPixel(int row, int col, int[] value){
		pixels[row][col] = value.clone();
	}
	
	public Matrix subMatrix(int rowStart, int rowEnd, int colStart, int colEnd){
		if(rowStart>=0 && rowEnd>rowStart && colStart>=0 && colEnd>colStart){
			int row = rowEnd-rowStart;
			int col = colEnd-colStart;
			
			Matrix matrix = new Matrix(row, col, this.getType());
			
			for(int i=0; i<row; i++){
				for(int j=0; j<col; j++){
					matrix.pixels[i][j] = this.pixels[rowStart+i][colStart+j];
				}
			}
			
			return matrix;
			
		}else{
			return new Matrix(1, 1, 1);
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static BufferedImage matrixToBufferedImage(Matrix mat){
		BufferedImage bufferedImage = new BufferedImage(mat.pixels[0].length, mat.pixels.length, BufferedImage.TYPE_4BYTE_ABGR);
		
		for(int i=0, j; i<mat.pixels.length; i++){
			for(j=0; j<mat.pixels[0].length; j++){
				bufferedImage.setRGB(j, i, rGBToInteger(mat.pixels[i][j]));
			}
		}
		
		return bufferedImage;
	}
	
	public static Matrix bufferedImageToMatrix(BufferedImage bufferedImage){
		int row = bufferedImage.getHeight();
		int col = bufferedImage.getWidth();
		
		Matrix matrix = new Matrix(row, col, RED_GREEN_BLUE_ALPHA);
		
		for(int i=0, j; i<row; i++){
			for(j=0; j<col; j++){
				matrix.pixels[i][j] = integerToRGB(bufferedImage.getRGB(j, i));
			}
		}
		
		return matrix;
	}
	
	public static int rGBToInteger(int[] rGBInt){
		Color color;
		
		if(rGBInt.length==BLACK_WHITE){
			color = new Color(rGBInt[0], rGBInt[0], rGBInt[0], 255);
		}else if(rGBInt.length==BLACK_WHITE_ALPHA){
			color = new Color(rGBInt[0], rGBInt[0], rGBInt[0], rGBInt[1]);
		}else if(rGBInt.length==RED_GREEN_BLUE){
			color = new Color(rGBInt[0], rGBInt[1], rGBInt[2], 255);
		}else{
			color = new Color(rGBInt[0], rGBInt[1], rGBInt[2], rGBInt[3]);
		}
		
		return color.getRGB();
	}
	
	public static int[] integerToRGB(int colorInt){
		Color color = new Color(colorInt, true);
		
		int[] colorRGB = {color.getRed(), color.getGreen(), color.getBlue(), color.getAlpha()};
		
		return colorRGB;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////

	public void write(String filePath) throws IOException{
		BufferedImage bufferedImage = matrixToBufferedImage(this);
		
		ImageIO.write(bufferedImage, filePath.substring(filePath.lastIndexOf('.')+1), new File(filePath));
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	/**TEST_ONLY**/
	public static void main(String[] args) {
		try {
			Matrix matrix = new Matrix("C:\\Users\\admin\\Desktop\\a.jpg");
			
			Matrix mat2 = matrix.subMatrix(50, 200, 50, 200);
			mat2 = MatrixUtil.rotate(mat2, 30);
			
			mat2.write("C:\\Users\\admin\\Desktop\\1.png");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
