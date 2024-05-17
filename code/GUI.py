import tkinter as tk
from tkinter import messagebox
import customtkinter as ctk
from customtkinter import filedialog, CTkFrame, CTkTextbox, CTkButton, CTkToplevel
import os

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
        self.textArea.tag_remove("error", "1.0", "end")

        with open("temp.cpp", "w") as file:
            file.write(self.textArea.get("1.0", tk.END))

        try:
            process = subprocess.Popen(
                ["cmd", "/c", f"type temp.cpp | {exe_path}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            output, error = process.communicate()
            print(error.decode())
            self.show_errors(
                [line for line in error.decode().split("\n") if line])

            self.display_text_table("tests/operationTable.txt", "OP table")
            self.display_text_table("tests/symbolTable.txt", "Symbol table")
        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {e}")

        os.remove("temp.cpp")

    def display_text_table(self, file_path, title="Table Window"):
        try:
            with open(file_path, "r") as file:
                content = file.read()

            # Create a new window
            table_window = CTkToplevel(self.root)
            table_window.title(title)

            # Create a frame to hold the table
            table_frame = CTkFrame(table_window)
            table_frame.pack(expand=True, pady=10)

            # Create the table
            table = CTkTextbox(table_frame,
                               font=("Courier", 14), wrap=tk.NONE, width=800, height=800)
            table.insert(tk.END, content)
            table.pack(expand=True, fill=tk.BOTH)

        except Exception as e:
            messagebox.showerror("Error", f"An error occurred: {e}")

    def show_errors(self, errors):

        for error in errors:
            message = error
            line = int(message.split(":")[1])
            start = f"{line}.0"
            end = f"{line}.0 lineend"

            self.textArea.tag_add("error", start, end)
            self.textArea.tag_config(f"error", foreground="red")


def main():
    root = ctk.CTk()
    app = FileTableApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
