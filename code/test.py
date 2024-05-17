import tkinter as tk
import customtkinter as ctk

# Create the main application window
root = ctk.CTk()

# Configure the root window
root.geometry("600x400")
root.title("CustomTkinter Text Box with Line Highlight")

# Create a text box widget
text_box = ctk.CTkTextbox(root, wrap="word", width=600, height=400)
text_box.pack(expand=True, fill="both")

# Sample text
sample_text = """Line 1: This is the first line.
Line 2: This is the second line.
Line 3: This is the line to highlight.
Line 4: This is another line."""

# Insert sample text into the text box
text_box.insert("1.0", sample_text)

# Function to highlight a specific line


def highlight_line(line_number):
    # Remove any existing tag
    text_box.tag_remove("highlight", "1.0", "end")

    # Split the text into lines
    lines = sample_text.split('\n')
    if line_number < 1 or line_number > len(lines):
        print("Invalid line number")
        return

    # Calculate the start and end indices of the specified line
    start_index = f"{line_number}.0"
    end_index = f"{line_number}.0 lineend"

    # Apply the highlight tag
    text_box.tag_add("highlight", start_index, end_index)
    text_box.tag_config("highlight", background="yellow")


# Highlight the third line
highlight_line(3)

# Run the Tkinter main loop
root.mainloop()
