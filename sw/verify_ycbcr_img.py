import numpy as np
import matplotlib.pyplot as plt

def read_ycbcr_image(filename, width, height):
    with open(filename, 'r') as file:
        data = file.readlines()

    # Initialize arrays for Y, Cb, and Cr components
    Y = np.zeros((height, width), dtype=np.uint8)
    Cb = np.zeros((height, width), dtype=np.uint8)
    Cr = np.zeros((height, width), dtype=np.uint8)

    # # Parse data from each line
    i=0
    j=0
    for line in data:
        values = line.strip().split(',')
        Y[i, j] = int(values[0], 16)
        Cb[i, j] = int(values[1], 16)
        Cr[i, j] = int(values[2], 16)
        j+=1
        if(j==320):
            j=0;
            i+=1

    return Y, Cb, Cr

def display_ycbcr_image(Y, Cb, Cr):
    # Display YCbCr components
    plt.figure(figsize=(10, 4))

    plt.subplot(1, 3, 1)
    plt.imshow(Y, cmap='gray')
    plt.title('Y (Luminance)')
    plt.axis('off')

    plt.subplot(1, 3, 2)
    plt.imshow(Cb, cmap='gray')
    plt.title('Cb (Blue Chrominance)')
    plt.axis('off')

    plt.subplot(1, 3, 3)
    plt.imshow(Cr, cmap='gray')
    plt.title('Cr (Red Chrominance)')
    plt.axis('off')

    plt.show()


def chroma_downsampling(Cb, Cr):
    # Downsample Cb and Cr by taking every second pixel in each dimension
    downsampled_Cb = Cb[::2, ::2]
    downsampled_Cr = Cr[::2, ::2]
    
    return downsampled_Cb, downsampled_Cr



# Example usage
filename = 'output.txt'  # Replace with your filename
width = 320  # Replace with the width of your image
height = 320  # Replace with the height of your image

Y, Cb, Cr = read_ycbcr_image(filename, width, height)
display_ycbcr_image(Y, Cb, Cr)

# Example usage
# Assuming you have Cb and Cr arrays already defined
downsampled_Cb, downsampled_Cr = chroma_downsampling(Cb, Cr)
print(np.shape(Cb))
print(f"Original length is {np.shape(Cb)}, downsampled len is {np.shape(downsampled_Cb)}")