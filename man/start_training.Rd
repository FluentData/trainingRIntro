% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/start_training.R
\name{start_training}
\alias{start_training}
\title{Start the training process automatically}
\usage{
start_training()
}
\value{
NULL, the function is intended to be used for its side effects of initiating a training lesson.
}
\description{
This function begins an automated training sequence, advancing through lessons sequentially.
It continues from the last incomplete lesson, checks user state to determine lesson completion,
and stops if it reaches beyond the defined number of lessons without finding an incomplete one.
It runs the next incomplete lesson and prepares the RStudio console for further commands.
}
\details{
The function iteratively checks the completion status of each lesson starting from the first.
If all lessons up to the eighth are marked complete, it will issue an error. It leverages
user state information, which should persist between sessions, to determine the starting point.
The function is intended for use within an interactive RStudio environment and utilizes
\code{rstudioapi} to manage console interactions.
}
