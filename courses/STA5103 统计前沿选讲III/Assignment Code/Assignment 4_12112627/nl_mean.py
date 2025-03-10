import numpy as np
from PIL import Image

def find_all_neighbors(padded_img, small_window, big_window, h, w):
    small_width = small_window // 2
    big_width = big_window // 2
    neighbors = np.zeros((padded_img.shape[0], padded_img.shape[1], small_window, small_window))
    for i in range(big_width, big_width + h):
        for j in range(big_width, big_width + w):
            neighbors[i, j] = padded_img[(i - small_width):(i + small_width + 1), (j - small_width):(j + small_width + 1)]
    return neighbors

def evaluate_norm(pixel_window, neighbor_window, norm_factor):
    numerator = 0
    denominator = 0
    for i in range(neighbor_window.shape[0]):
        for j in range(neighbor_window.shape[1]):
            q_window = neighbor_window[i, j]
            q_x, q_y = q_window.shape[0] // 2, q_window.shape[1] // 2
            intensity_q = q_window[q_x, q_y]
            weight = np.exp(-1 * (np.sum((pixel_window - q_window) ** 2) / norm_factor))
            numerator += weight * intensity_q
            denominator += weight
    return numerator / denominator

def nlm_filter(padded_img, img, h, small_window, big_window):
    norm_factor = (h ** 2) * (small_window ** 2)
    height, width = img.shape
    result = np.zeros(img.shape)
    big_width = big_window // 2
    small_width = small_window // 2
    neighbors = find_all_neighbors(padded_img, small_window, big_window, height, width)
    for i in range(big_width, big_width + height):
        for j in range(big_width, big_width + width):
            pixel_window = neighbors[i, j]
            neighbor_window = neighbors[(i - big_width):(i + big_width + 1), (j - big_width):(j + big_width + 1)]
            intensity_p = evaluate_norm(pixel_window, neighbor_window, norm_factor)
            result[i - big_width, j - big_width] = max(min(255, intensity_p), 0)
        # print(i)
    return result

def nlm_denoise(img, h=30, small_window=7, big_window=21):
    padded_img = np.pad(img, big_window // 2, mode='reflect')
    return nlm_filter(padded_img, img, h, small_window, big_window)

def main():
    input_image_path = "noisy.jpg"
    output_image_path = "denoised.jpg"
    h = 30
    small_window = 7
    big_window = 21

    img = Image.open(input_image_path).convert('L')
    img_array = np.array(img)
    denoised_img_array = nlm_denoise(img_array, h, small_window, big_window)
    denoised_img = Image.fromarray(denoised_img_array.astype(np.uint8))
    denoised_img.save(output_image_path)

if __name__ == "__main__":
    main()
