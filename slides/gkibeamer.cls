%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 
%%% wrapper class for beamer with some layout defaults
%%% and a "4-on-1" option for handouts
%%%
%%% Copyright: Malte Helmert and Gabriele Roeger
%%% All rights reserved 
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e} 
\ProvidesClass{gkibeamer}[2012/02/37 v0.2 beamer wrapper class]
\RequirePackage{ifthen}

\newboolean{hand@out}
\newboolean{four@on@one}

\DeclareOption{handout}{
  \setboolean{hand@out}{true}
  \PassOptionsToClass{handout}{beamer}
}
\DeclareOption{4-on-1}{
  \setboolean{four@on@one}{true}
}
\DeclareOption*{
  \PassOptionsToClass{\CurrentOption}{beamer}
}
\ProcessOptions

\def\lecture@no{}
\newcommand{\lectureno}[1]{\edef\lecture@no{#1}}
\newcommand{\the@lectureno}{%
  \ifthenelse{\equal{\lecture@no}{}}{}{\lecture@no.}}

\newcommand{\insertsectionprefix}{\relax}
\newcommand{\insertsectionsuffix}{\relax}

\LoadClass{beamer}


\iffour@on@one
  \RequirePackage{pgf}
  \RequirePackage{pgfpages}

  \definecolor{pagebordercolor}{rgb}{0.129216,0.188235,0.709804}

  \newcounter{@remainder}%
  \newcommand{\set@remainder}[2]{%
    \setcounter{@remainder}{#1}%
    \loop%
    \ifnum\the@remainder<#2\relax%
    \else%
    \addtocounter{@remainder}{-#2}%
    \repeat%
  }

  \newcounter{pageno@temp}
  \newcommand{\border@ifnecessary}[1]{%
    \setcounter{pageno@temp}{\thepage}%
    \addtocounter{pageno@temp}{2}%
    \set@remainder{\thepageno@temp}{4}%
    \addtocounter{@remainder}{2}%
    \ifnum#1<\the@remainder\relax%
    \color{pagebordercolor}\pgfsetlinewidth{2pt}\pgfstroke%
    \fi%
  }

  \pgfpagesdeclarelayout{my@pagelayout}
  {
    \edef\pgfpageoptionheight{\the\paperheight} 
    \edef\pgfpageoptionwidth{\the\paperwidth}
    \edef\pgfpageoptionborder{0pt}
  }
  {
    \pgfpagesphysicalpageoptions
    {%
      logical pages=4,%
      physical height=\pgfpageoptionheight,%
      physical width=\pgfpageoptionwidth%
    }
    \pgfpageslogicalpageoptions{1}
    {%
      border code=\border@ifnecessary{1},%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=.5\pgfphysicalheight,%
      center=\pgfpoint{.25\pgfphysicalwidth}{.75\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{2}
    {%
      border code=\border@ifnecessary{2},%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=.5\pgfphysicalheight,%
      center=\pgfpoint{.75\pgfphysicalwidth}{.75\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{3}
    {%
      border code=\border@ifnecessary{3},%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=.5\pgfphysicalheight,%
      center=\pgfpoint{.25\pgfphysicalwidth}{.25\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{4}
    {%
      border code=\border@ifnecessary{4},%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=.5\pgfphysicalheight,%
      center=\pgfpoint{.75\pgfphysicalwidth}{.25\pgfphysicalheight}%
    }%
  }

  \pgfpagesuselayout{my@pagelayout}[a4paper,landscape,border shrink=5mm]
\fi

\usetheme{AI}

\ifhand@out
  \defbeamertemplate{section in toc}{our style}
  {\leavevmode\begin{Large}\hilite{\the@lectureno\inserttocsectionnumber\ \inserttocsection}\end{Large}\par}

  \defbeamertemplate{subsection in toc}{our style}
  {\leavevmode\leftskip=5ex\llap{%
      \usebeamercolor[bg]{subsection number projected}%
          \vrule width1ex height1ex\kern1ex}\inserttocsubsection\par}
  \setbeamertemplate{sections/subsections in toc}[our style]

  \g@addto@macro\beamer@lastminutepatches{
    \let\origsubtitle\insertsubtitle
    \let\origsubtitleshort\insertsubtitleshort
    \subtitle[\the@lectureno\ \origsubtitleshort]{\the@lectureno\ \origsubtitle}
    \begin{frame}
      \titlepage
    \end{frame}
    \begin{frame}
      \frametitle{\inserttitle}
      \framesubtitle{{\insertdate} --- {\insertsubtitle}}
      \tableofcontents
    \end{frame}
  }

\AtBeginSection[%
    \begin{frame}%
        \begin{huge}
            \hilite{\the@lectureno\@arabic\c@section\ \insertsection}
        \end{huge}
     \end{frame}%
]%
{%
    \subsection{}%
    \begin{frame}%
        \begin{huge}
            \hilite{\the@lectureno\@arabic\c@section\ \insertsection}
        \end{huge}
     \end{frame}%
} 

\else
  \AtBeginDocument{
    \let\origsubtitle\insertsubtitle
    \let\origsubtitleshort\insertsubtitleshort
    \subtitle[\the@lectureno\ \origsubtitleshort]{\the@lectureno\ \origsubtitle}
    \begingroup
    \begin{frame}[noframenumbering]
      \titlepage
    \end{frame}
  }

\AtBeginSection[%
    \begin{frame}%
      \begin{huge}
        \begin{center}
          \insertsectionprefix
          \hilite{\insertsection}%
          \insertsectionsuffix
        \end{center}
      \end{huge}
    \end{frame}%
]%
{%
    \subsection{}%
    \begin{frame}[noframenumbering]%
        \begin{huge}
          \begin{center}
          \insertsectionprefix
          \hilite{\insertsection}%
          \insertsectionsuffix
          \end{center}
        \end{huge}
    \end{frame}%
} 

\fi
   

