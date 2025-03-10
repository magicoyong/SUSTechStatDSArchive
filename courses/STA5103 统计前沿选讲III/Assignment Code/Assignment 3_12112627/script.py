import numpy as np
import cv2
import glob
import os

def bilinear_interpolation(image, new_height, new_width):
    height, width = image.shape
    resized_image = np.zeros((new_height, new_width), dtype=image.dtype)
    print(new_height, new_width)
    x_scale = width / new_width
    y_scale = height / new_height

    for y in range(new_height):
        for x in range(new_width):
            src_x = x * x_scale
            src_y = y * y_scale

            x0, y0 = int(src_x), int(src_y)
            x1, y1 = min(x0 + 1, width - 1), min(y0 + 1, height - 1)

            a = src_x - x0
            b = src_y - y0

            interpolated_value = (
                (1 - a) * (1 - b) * image[y0, x0] +
                a * (1 - b) * image[y0, x1] +
                (1 - a) * b * image[y1, x0] +
                a * b * image[y1, x1]
            )
            resized_image[y, x] = int(interpolated_value)

    return resized_image

output_dir = 'extracted_frames'
new_output_dir = 'high_res_frames'
os.makedirs(output_dir, exist_ok=True)
os.makedirs(new_output_dir, exist_ok=True)

video_path = 'cargray.avi'
cap = cv2.VideoCapture(video_path)

if not cap.isOpened():
    print("Error: Cannot open the video file.")
else:
    frame_index = 0
    b_flag = False
    while cap.isOpened():
        ret, frame = cap.read()
        if not b_flag:
            rows, cols = frame.shape[:2]
            b_flag = True
        if ret:
            if len(frame.shape) == 3:
                frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            frame_filename = os.path.join(output_dir, f'frame_{frame_index:04d}.png')
            cv2.imwrite(frame_filename, frame)
            print(f"Saved {frame_filename}")
            n, m = frame.shape
            new_n, new_m = 2 * n - 1, 2 * m - 1
            high_res_frame = bilinear_interpolation(frame, new_n, new_m)
            new_frame_filename = os.path.join(new_output_dir, f'high_res_frame_{frame_index:04d}.png')
            cv2.imwrite(new_frame_filename, high_res_frame)
            print(f"Saved {new_frame_filename}")
            frame_index += 1
        else:
            break

    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    print(f"Number of frames (f): {frame_count}")
    print(f"Number of rows (n): {rows}")
    print(f"Number of columns (m): {cols}")
    cap.release()

new_output_video_path = 'newcargray.avi'
frame_rate = 16

frame_files = sorted(glob.glob('high_res_frames/high_res_frame_*.png'))

first_frame = cv2.imread(frame_files[0], cv2.IMREAD_GRAYSCALE)
frame_height, frame_width = first_frame.shape

fourcc = cv2.VideoWriter_fourcc(*'MJPG')
out = cv2.VideoWriter(new_output_video_path, fourcc, frame_rate, (frame_width, frame_height), isColor=False)

for frame_file in frame_files:
    frame = cv2.imread(frame_file, cv2.IMREAD_GRAYSCALE)
    out.write(frame)

out.release()