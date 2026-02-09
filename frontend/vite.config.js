import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  build: {
    outDir: 'build',          // ← Change output folder name here
    emptyOutDir: true         // Optional: Clean the folder before each build (good practice)
  }
})
