import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'build',          // ← Change output folder name here
    emptyOutDir: true         // Optional: Clean the folder before each build (good practice)
  }
})
