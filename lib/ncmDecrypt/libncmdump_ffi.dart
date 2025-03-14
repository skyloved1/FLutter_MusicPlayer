import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

// Define C function signature
typedef DecryptFileC = Void Function(
    Pointer<Utf8> inputPath, Pointer<Utf8> outputPath);
typedef DecryptFileDart = void Function(
    Pointer<Utf8> inputPath, Pointer<Utf8> outputPath);

// Load DLL
final DynamicLibrary libncmdump = Platform.isWindows
    ? DynamicLibrary.open('assets/dll/libncmdump.dll')
    : DynamicLibrary.process();

// Get function pointer
final DecryptFileDart decryptFile =
    libncmdump.lookup<NativeFunction<DecryptFileC>>('decryptFile').asFunction();
