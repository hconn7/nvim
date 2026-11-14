return {
  'Civitasv/cmake-tools.nvim',
  ft = { 'c', 'cpp', 'objc', 'objcpp', 'cmake' }, -- Lazy-load on C/C++/CMake files
  opts = {
    cmake_build_directory = 'build',
    -- Automatically pass the flag to generate compile_commands.json for clangd
    cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=1' },
    cmake_soft_link_compile_commands = true, -- Auto-links compile_commands.json to root
  },
}
