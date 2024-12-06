from PIL import Image
import os

def remove_black_pixels(input_folder, output_folder):
    # Ensure the output folder exists
    os.makedirs(output_folder, exist_ok=True)
    
    for filename in os.listdir(input_folder):
        if filename.endswith(".png"):
            file_path = os.path.join(input_folder, filename)
            
            # Open the image
            with Image.open(file_path) as img:
                img = img.convert("RGBA")  # Ensure the image has an alpha channel
                pixels = img.load()
                
                # Iterate through each pixel
                for y in range(img.height):
                    for x in range(img.width):
                        r, g, b, a = pixels[x, y]
                        # If the pixel is black, set it to fully transparent
                        if (r, g, b) == (0, 0, 0):
                            pixels[x, y] = (0, 0, 0, 0)
                
                # Save the modified image
                output_path = os.path.join(output_folder, filename)
                img.save(output_path)
                print(f"Processed and saved: {output_path}")

def scale_image(input_folder, output_folder, target_size=(12, 12)):
    # Ensure the output folder exists
    os.makedirs(output_folder, exist_ok=True)
    
    for filename in os.listdir(input_folder):
        if filename.endswith(".png"):
            file_path = os.path.join(input_folder, filename)
            
            # Open the image
            with Image.open(file_path) as img:
                # Scale the image using nearest-neighbor interpolation
                img_resized = img.resize(target_size, Image.NEAREST)
                
                # Save the scaled image
                output_path = os.path.join(output_folder, filename)
                img_resized.save(output_path)
                print(f"Scaled and saved: {output_path}")

def change_sprites(input_folder, output_folder, target_size=(12, 12)):
    # Ensure the output folder exists
    os.makedirs(output_folder, exist_ok=True)
    
    for filename in os.listdir(input_folder):
        if filename.endswith(".png"):
            file_path = os.path.join(input_folder, filename)
            
            # Open the image
            with Image.open(file_path) as img:
                img = img.convert("RGBA")  # Ensure the image has an alpha channel
                pixels = img.load()
                
                # Iterate through each pixel
                for y in range(img.height):
                    for x in range(img.width):
                        r, g, b, a = pixels[x, y]
                        # If the pixel is black, set it to fully transparent
                        if (r, g, b) == (0, 0, 0):
                            pixels[x, y] = (0, 0, 0, 0)
                
                # Scale the image using nearest-neighbor interpolation
                img_resized = img.resize(target_size, Image.NEAREST)
                img_resized = img_resized.convert("RGBA")  # Ensure it has an alpha channel
                pixels = img_resized.load()
                
                # Remove the outermost pixels
                width, height = img_resized.size
                for x in range(width):
                    pixels[x, 0] = (0, 0, 0, 0)         # Top row
                    pixels[x, height - 1] = (0, 0, 0, 0) # Bottom row
                for y in range(height):
                    pixels[0, y] = (0, 0, 0, 0)         # Left column
                    pixels[width - 1, y] = (0, 0, 0, 0) # Right column
                
                # Save the modified image
                output_filename = filename
                # output_filename = f"small_{filename}"
                
                output_path = os.path.join(output_folder, output_filename)
                img_resized.save(output_path)
                print(f"Processed and saved: {output_path}")

def add_black_outline(input_folder, output_folder):
    # Ensure the output folder exists
    os.makedirs(output_folder, exist_ok=True)

    for filename in os.listdir(input_folder):
        if filename.endswith(".png"):
            file_path = os.path.join(input_folder, filename)
            
            # Open the image
            with Image.open(file_path) as img:
                img = img.convert("RGBA")  # Ensure the image has an alpha channel
                width, height = img.size
                
                # Create a new blank image with transparency for the outline
                outlined_img = Image.new("RGBA", (width, height), (0, 0, 0, 0))
                original_pixels = img.load()
                outlined_pixels = outlined_img.load()
                
                # Add black outline around each non-transparent pixel
                for y in range(height):
                    for x in range(width):
                        r, g, b, a = original_pixels[x, y]
                        if a > 0:  # If the pixel is not fully transparent
                            # Set the surrounding pixels to black if they are transparent
                            for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:  # Four neighboring positions
                                nx, ny = x + dx, y + dy
                                if 0 <= nx < width and 0 <= ny < height:  # Check bounds
                                    _, _, _, na = original_pixels[nx, ny]
                                    if na == 0:  # Only add black outline where the neighbor is transparent
                                        outlined_pixels[nx, ny] = (0, 0, 0, 255)
                            # Copy the original pixel to the new image
                            outlined_pixels[x, y] = (r, g, b, a)
                

                # Save the outlined image
                output_path = os.path.join(output_folder, filename)
                outlined_img.save(output_path)
                print(f"Outlined and saved: {output_path}")

def normalize_path(path: str) -> str:
    return path.replace("\\", "/")

# Define input and output directories
input_folder = "C:\\Users\\Admin\\Desktop\\MedievalStoreManager\\GuildManager2d\\Asset\\ShopItem"  # Replace with the folder containing your images
output_folder = "C:\\Users\\Admin\\Desktop\\MedievalStoreManager\\GuildManager2d\\Asset\\ShopItem\\SmallVersion"  # Replace with your desired output folder

change_sprites(normalize_path(input_folder), normalize_path(output_folder))

add_black_outline(normalize_path(output_folder), normalize_path(output_folder))

# remove_black_pixels(input_folder, output_folder)

# scale_image(input_folder, output_folder)
