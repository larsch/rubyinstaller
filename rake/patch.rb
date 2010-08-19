def find_git
  ENV["PATH"].split(File::PATH_SEPARATOR).each do |path|
    ENV["PATHEXT"].split(File::PATH_SEPARATOR).each do |sep|
      candidate = File.join(path, "git" + sep)
      return candidate if File.exist?(candidate)
    end
  end
end

def find_git_exe
  git = find_git
  if File.extname(git) =~ /^\.(cmd|bat)$/i
    git_exe = File.expand_path(File.join(File.dirname(git), "../bin/git.exe"))
    return git_exe if File.exist?(git_exe)
  end
  return git
end

def patch(directory, patch)
  $git_exe ||= find_git_exe
  sh $git_exe, "apply", "--whitespace=fix", "--directory", directory, patch
end
