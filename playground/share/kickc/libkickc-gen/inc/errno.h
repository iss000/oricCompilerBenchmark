/**
 * @file errno.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Contains the POSIX implementation of errno, which contains the last error detected.
 * @version 0.1
 * @date 2023-03-18
 * 
 * @copyright Copyright (c) 2023
 * 
 */

/// @brief  We POSIX standard specifies errno to be an int. We refer to it as part of the header file.
/// However, for practical purposes we don't keep errno but we keep a char array containing the last meaningful message.
/// Having the translate the error from errno would be too much memory consuming.
extern char __errno_error[32];

extern int __errno;