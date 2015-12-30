/****************************************************************************************************************
* Developer: Minhas Kamal(BSSE-0509, IIT, DU)																	*
* Date: 10-Mar-2015																								*
****************************************************************************************************************/

package matrix;

import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

public class MatrixUtil {
	/**
	 * Compares two <code>Matrix</code>s and represents their similarity in a double type number.
	 * This method uses simple algorithm and static pixel comparison. Both matrix must be in same size.
	 * @param mat1 <code>Matrix</code> for comparing
	 * @param mat2 <code>Matrix</code> that is compared to mat1
	 * @return similarity of the two <code>Matrix</code>s
	 */
	public static double compareMatrix(Matrix mat1, Matrix mat2, int tolerance){
		int rows = mat1.getRow(),
			cols = mat1.getCol();
		
		
		double sumOfDissimilarityByRow = 0;
		double sumOfDissimilarity = 0;
		
		for(int row=0, col; row<rows; row++){
			sumOfDissimilarityByRow = 0;
			
			for(col=0; col<cols; col++){
				sumOfDissimilarityByRow += findDifference(mat1.getPixel(row, col), mat2.getPixel(row, col), tolerance);
			}
			sumOfDissimilarity += sumOfDissimilarityByRow/2.55/cols;
		}
		
		double dissimilarity = sumOfDissimilarity/rows;
		
		return (100-dissimilarity);
	}
	

	/**
	 * Find difference in two doubles
	 * @param a
	 * @param b
	 * @param tolerance
	 * @return
	 */
	private static int findDifference(int[] a, int[] b, int tolerance){
		int difference=0;
		
		int dif=0;
		for(int i=a.length-1; i>=0; i--){
			dif = (int) (a[i]-b[i]);
			
			if(dif<0){
				dif = -dif;
			}
			
			difference += dif;
		}
		
		if(difference<tolerance){
			return 0;
		}else{
			return difference;
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////

	public static Matrix resize(Matrix matrix, int scaledWidth, int scaledHeight){
		BufferedImage originalBufferedImage = Matrix.matrixToBufferedImage(matrix);
		BufferedImage scaledBufferedImage = new BufferedImage(scaledWidth, scaledHeight, originalBufferedImage.getType());

		Graphics2D g = scaledBufferedImage.createGraphics();
    	g.drawImage(originalBufferedImage, 0, 0, scaledWidth, scaledHeight, null); 
    	g.dispose();
    	
    	return Matrix.bufferedImageToMatrix(scaledBufferedImage);
    }
	
	public static Matrix rotate(Matrix matrix, float degree){
		if(degree<0){
			matrix = flipVertical(matrix);
			degree = -degree;
		}
		
		BufferedImage originalBufferedImage = Matrix.matrixToBufferedImage(matrix);
		BufferedImage rotatedBufferedImage = new BufferedImage
				(originalBufferedImage.getWidth(), originalBufferedImage.getHeight(), originalBufferedImage.getType());
		
		AffineTransform affineTransform = new AffineTransform();
		affineTransform.rotate(Math.toRadians(degree), 0, rotatedBufferedImage.getHeight());
	    AffineTransformOp affineTransformOp = new AffineTransformOp(affineTransform, AffineTransformOp.TYPE_BILINEAR);
	    rotatedBufferedImage = affineTransformOp.filter(originalBufferedImage, null);
	    
		Matrix newMatrix = Matrix.bufferedImageToMatrix(rotatedBufferedImage);
	    int cropTop = (int) ( matrix.getRow() * (1-Math.cos(Math.toRadians(degree))) );
		return newMatrix.subMatrix(cropTop, newMatrix.getRow(), 0, newMatrix.getCol());
	}
	
	public static Matrix flipVertical(Matrix matrix){
		int row = matrix.getRow();
		int col = matrix.getCol();
		
		Matrix matrix2 = new Matrix(row, col, matrix.getType());
		
		for(int i=0; i<row; i++){
			for(int j=0; j<col; j++){
				matrix2.setPixel(i, col-j-1, matrix.getPixel(i, j));
			}
		}
		
		return matrix2;
	}
	
	public static Matrix flipHorizontal(Matrix matrix){
		int row = matrix.getRow();
		int col = matrix.getCol();
		
		Matrix matrix2 = new Matrix(row, col, matrix.getType());
		
		for(int i=0; i<row; i++){
			for(int j=0; j<col; j++){
				matrix2.setPixel(row-i-1, j, matrix.getPixel(i, j));
			}
		}
		
		return matrix2;
	}

	public static Matrix crop(Matrix matrix, int left, int right, int top, int down){
		return matrix.subMatrix(top, matrix.getRow()-down, left, matrix.getCol()-right);
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static Matrix cropEdge(Matrix matrix){
		Matrix mat = matrix;
		int top = getEdge(mat);
		mat = MatrixUtil.rotate(mat, 90);
		int left = getEdge(mat);
		mat = MatrixUtil.rotate(mat, 90);
		int down = getEdge(mat);
		mat = MatrixUtil.rotate(mat, 90);
		int right = getEdge(mat);
		
		return crop(matrix, left, right, top, down);
	}
	
	public static int getEdge(Matrix matrix){
		int edge=0;
		
		int row = matrix.getRow();
		int col = matrix.getCol();
		
		for(int i=0; i<row; i++){
			for(int j=0; j<col; j++){
				int[] pixel = matrix.getPixel(i, j);
				if(Math.abs(pixel[0]-pixel[1]) > 3 || Math.abs(pixel[0]-pixel[2]) > 3){
					return edge;
				}
			}
			edge++;
		}
		
		return edge;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static void write(Matrix matrix, String filePath) throws IOException{
		BufferedImage bufferedImage = Matrix.matrixToBufferedImage(matrix);
		
		ImageIO.write(bufferedImage, filePath.substring(filePath.lastIndexOf('.')+1), new File(filePath));
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////

	public static void main(String[] args) throws IOException {
		Matrix matrix = new Matrix("C:\\Users\\admin\\Desktop\\a.jpg");
		
		//matrix = rotate(matrix, 20);
		
//		matrix = flipHorizontal(matrix);
//		MatrixUtil.write(matrix, "C:\\Users\\admin\\Desktop\\d.png");
		
		matrix = crop(matrix, 20, 80, 10, 50);
		MatrixUtil.write(matrix, "C:\\Users\\admin\\Desktop\\e.png");
	}
}
