import tkinter as tk
from tkinter import messagebox
import customtkinter as ctk
from customtkinter import filedialog, CTkFrame, CTkTextbox, CTkButton, CTkToplevel
import pandas as pd
from pandastable import Table, TableModel

import subprocess


class FileTableApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Best IDE Ever!!!")

        self._create_toolbar()

        self._create_textArea()

        self.file_button = CTkButton(
            root, text="Compile", command=self.compile_and_show)
        self.file_button.pack(pady=10)

    def _create_toolbar(self):
        self.toolbar = CTkFrame(self.root)
        self.toolbar.pack(side=tk.TOP, fill=tk.X)

        self.select_file_button = CTkButton(
            self.toolbar, text="Select a file", command=self.browse_file, font=("Arial", 12),
            width=30, corner_radius=0
        )
        self.select_file_button.pack(side=tk.LEFT)

    def _create_textArea(self):
        self.textArea_label = ctk.CTkLabel(
            self.root, text="Code ahead..", font=("Sans Serif", 14))
        self.textArea_label.pack(pady=10)
        self.textArea = CTkTextbox(self.root, font=("Arial", 16))
        self.textArea.pack(expand=True, fill=tk.BOTH, padx=10, pady=10)

        # bind ctrl + = to increase font size
        self.root.bind("<Control-equal>", self._increase_font_size)
        # bind ctrl + minus to decrease font size
        self.root.bind("<Control-minus>", self._decrease_font_size)

    def _increase_font_size(self, event):
        font_size = self.textArea.cget("font")[1]
        font_size += 2
        self.textArea.configure(font=("Arial", font_size))

    def _decrease_font_size(self, event):
        font_size = self.textArea.cget("font")[1]
        font_size -= 2
        self.textArea.configure(font=("Arial", font_size))

    def browse_file(self):
        file_path = filedialog.askopenfilename(
            # filetypes=[("CSV files", "*.csv"), ("Excel files", "*.xlsx")])
            filetypes=[("C++ files", "*.cpp"), ("C files", "*.c")])
        if file_path:
            try:
                self.read_file(file_path)
            except Exception as e:
                messagebox.showerror("Error", f"An error occurred: {e}")

    def read_file(self, file_path):
        try:
            with open(file_path, "r") as file:
                content = file.read()
                self.textArea.delete("1.0", tk.END)
                self.textArea.insert(tk.END, content)
        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {e}")

    def compile_and_show(self):
        exe_path = "build\\c_compiler.exe"
        # Create a PIPE for capturing standard output
        process = subprocess.Popen(
            [exe_path], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        # Encode input for compatibility (adjust encoding if needed)
        input_text = self.textArea.get("1.0", tk.END)
        encoded_input = input_text.encode('utf-8')
        # Send input to the EXE
        process.stdin.write(encoded_input)
        # Close standard input to prevent accidental mixing with output
        process.stdin.close()
        # Capture output and potential errors
        output, error = process.communicate()
        # Decode output for readability (adjust encoding if needed)
        decoded_output = output.decode('utf-8')

        print(decoded_output, error)

    def display_table(self, file_path):
        try:
            if file_path.endswith('.csv'):
                df = pd.read_csv(file_path)
            elif file_path.endswith('.xlsx'):
                df = pd.read_excel(file_path)
            else:
                raise ValueError("Unsupported file format")

            # Create a new window
            table_window = CTkToplevel(self.root)
            table_window.title("Table Window")

            # Create a frame to hold the table
            table_frame = CTkFrame(table_window)
            table_frame.pack(expand=True, pady=10)

            # Create the table
            table = Table(table_frame, dataframe=df,
                          showtoolbar=True, showstatusbar=True)
            table.show()

        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {e}")


def main():
    root = ctk.CTk()
    app = FileTableApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
