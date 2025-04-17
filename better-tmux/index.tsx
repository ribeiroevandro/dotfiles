import { type BetterTmuxConfig, Box, type WindowConfig, useTheme } from 'better-tmux'
import { Clock, Hostname } from 'better-tmux/widgets'

const Window = ({ type, number, name }: WindowConfig) => {
  const theme = useTheme()
  return (
    <Box 
      padding={1} 
      bg={type === 'active' ? theme.primary : theme.background}
      fg={type === 'active' ? theme.background : theme.foreground}
    >
      {number}: {name}
    </Box>
  )
}

const CustomStatusLeft = () => {
  const theme = useTheme()

  return (
    <Box>
      <Hostname />
      <Box bg={theme.primary} padding={1}>🚀</Box>
      <Box bg={theme.background} fg={theme.foreground} padding={1}>Test</Box>
    </Box>

  )
}

export default {
  theme: 'catppuccin-mocha',
  status: {
    left: <CustomStatusLeft />,
    right: <Clock />
  },
  window: (window) => <Window {...window} />
} satisfies BetterTmuxConfig
