import {
  type BetterTmuxConfig,
  type WindowConfig,
  Box,
  useTheme,
  tmux,
  type Bind,
} from 'better-tmux'
import { Clock, Date, Hostname, SessionName, Widget, WidgetLabel } from 'better-tmux/widgets'
import { icons } from "./icons"

const WindowBellFlag = () => {
  return `#{?window_bell_flag,${icons.bell},}`
}
const Zoom = () => {
  return `#{?window_zoomed_flag, ${icons.zoom},}`
}

const Prefix = () => {
  return `#{?client_prefix,${icons.prefix}  ,}`
}

const Ghost = () => (
  <Box>
    <WindowBellFlag />
    <Zoom />
  </Box>
)

const Window = ({ type, number, name }: WindowConfig) => {
  const theme = useTheme()
  return (
    <Box
      padding={2}
      bg={type === 'active' ? theme.primary : theme.background}
      fg={type === 'active' ? theme.background : theme.foreground}
    >
      {number}::{name}<Ghost />
    </Box>
  )
}

const CustomStatusLeft = () => {
  return (
    <SessionName />
  )
}

const Clima = () => {
  return (
    <Widget>
      <WidgetLabel>
        {`#(npx clima 28640000?format=1; sleep 900)`}
      </WidgetLabel>
    </Widget>
  )
}

const CustomStatusRight = () => (
  <Box>
    <Prefix />
    <Clima />
    <Date format={`${tmux.globals.abbreviated_day}, ${tmux.globals.day} ${tmux.globals.abbreviated_month}`} />
    <Clock />
    <Hostname />
  </Box>
)

const bindings = [
  {
    key: `\\\\`,
    command: 'split-window',
    options: ['-h', '-c', '"#{pane_current_path}"']
  },
  {
    key: '-',
    command: 'split-window',
    options: ['-v', '-c', '"#{pane_current_path}"']
  },
  {
    key: 'h',
    command: 'select-pane',
    options: ['-L']
  },
  {
    key: 'l',
    command: 'select-pane',
    options: ['-R']
  },
  {
    key: 'k',
    command: 'select-pane',
    options: ['-U']
  },
  {
    key: 'j',
    command: 'select-pane',
    options: ['-D']
  },
  {
    key: 'H',
    command: 'resize-pane',
    options: ['-L', '15']
  },
  {
    key: 'L',
    command: 'resize-pane',
    options: ['-R', '15']
  },
] satisfies Bind[]

export default {
  bindings,
  theme: "catppuccin-mocha",
  status: {
    bg: "#1C1C29",
    fg: "#FB0C10",
    left: <CustomStatusLeft />,
    right: <CustomStatusRight />,
  },
  window: (window) => <Window {...window} />,
  options: {
    prefix: "C-b",
    // adicionar opções on | off
    mouse: "on",
    statusKeys: "vi",
    modeKeys: "vi",
    defaultTerminal: "tmux-256color",
    terminalOverrides: ",*256col*:Tc",
    escapeTime: 10,
    historyLimit: 10000,
  },
} satisfies BetterTmuxConfig